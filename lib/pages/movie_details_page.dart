import 'package:fav_movies/domain/db/movie_db.dart';
import 'package:fav_movies/domain/movie.dart';
import 'package:fav_movies/utils/constants.dart';
import 'package:flutter/material.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  double movieRating = 2.5;

  var favColor = Colors.white;

  Movie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(movie),
    );
  }

  _buildBody(Movie movie) {
    return _sliverList(movie);
  }

  _sliverList(Movie movie) {
    String name = movie.title;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          elevation: 8.0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Icon(
                  Icons.favorite,
                  color: favColor,
                ),
                onTap: () {
                  setState(() {
                    favColor = Colors.red;
                    //TODO salvar movie na base
                    _onClickFav(context, movie);
                  });
                },
              ),
            )
          ],
          expandedHeight: 300.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              name,
              style: TextStyle(
                  backgroundColor: Colors.black54, decorationThickness: 30),
            ),
            titlePadding: EdgeInsets.only(left: 50, bottom: 20),
            collapseMode: CollapseMode.parallax,
            background: _movieImage(movie),
          ),
        ),
        SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        movie.releaseDate,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  movie.overview,
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _movieImage(Movie movie) {
    return Image.network(
      IMAGE_URL_500 + movie.pathBackdrop,
      fit: BoxFit.fitHeight,
    );
  }

  _formattedDate(String date) {
    DateTime dateFormatted = DateTime.parse(date);
  }

  Future _onClickFav(BuildContext context, movie) async {
      final db = MovieDB.getInstance();

      print("Filme salvo! movies");
  }
}

