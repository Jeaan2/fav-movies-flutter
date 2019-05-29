import 'package:fav_movies/domain/db/movie_db.dart';
import 'package:fav_movies/domain/movie.dart';
import 'package:fav_movies/domain/services/movies_service.dart';
import 'package:fav_movies/pages/movie_details_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:fav_movies/utils/constants.dart';
import 'package:fav_movies/utils/nav.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
      appBar: AppBar(
        title: Text("Fav Movies"),
        centerTitle: true,
        backgroundColor: Colors.black54,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.movie)),
            Tab(icon: Icon(Icons.favorite))
          ],
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Container(
          child: _gridViewAllMoviesBody(context, 'movie'),
        ),
        Container(
          child: _gridViewFavMoviesBody(context, 'fav'),
        )
      ],
    );
  }

  _gridViewAllMoviesBody(BuildContext context, type) {
    Future<List<Movie>> movies = MovieService.getMovies();

    return FutureBuilder<List<Movie>>(
      future: movies,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _staggeredGridViewBody(snapshot.data);
      },
    );
  }

  _gridViewFavMoviesBody(BuildContext context, String s) {
    //TODO get movies from preferences
    Future<List<Movie>> favMovies = MovieDB.getInstance().getAllMovies();

    return FutureBuilder<List<Movie>>(
      future: favMovies,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _staggeredGridViewBody(snapshot.data);
      },
    );
  }

  _staggeredGridViewBody(List<Movie> data) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: data.length,
      itemBuilder: (context, idc) {
        return InkWell(
          onTap: () {
            push(
                context,
                MovieDetailsPage(
                  movie: data[idc],
                ));
          },
          child: Container(
            color: Colors.black54,
            child: CachedNetworkImage(
              imageUrl: IMAGE_URL_400 + data[idc].pathPoster,
              placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.extent(2, 300),
    );
  }
}
