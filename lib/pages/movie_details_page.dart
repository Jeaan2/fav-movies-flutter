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
  bool fav = false;

  Movie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _buildBody(movie),
      backgroundColor: Colors.black,
    );
  }

  _buildBody(Movie movie) {
    return _sliver(movie);
  }

  _sliver(Movie movie) {
    String name = movie.title;

    return SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white, size: 40),
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
                          _onClickFav(context, movie);
                          if (fav) {
                            favColor = Colors.white;
                          } else {
                            favColor = Colors.red;
                          }
                        });
                      },
                    ),
                  )
                ],
                expandedHeight: 300.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 20, bottom: 20),
                  collapseMode: CollapseMode.parallax,
                  background: _movieImageBackdrop(movie),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 50.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Text(
                      "Data de lançamento: ",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      movie.releaseDate,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0)),
                Column(
                  children: <Widget>[
                    Text(
                      movie.overview,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _movieImageBackdrop(Movie movie) {
    return Image.network(
      IMAGE_URL_500 + movie.pathBackdrop,
      fit: BoxFit.fitHeight,
    );
  }

  _movieImagePoster(Movie movie) {
    return Image.network(
      IMAGE_URL_500 + movie.pathPoster,
      fit: BoxFit.fitHeight,
    );
  }

  Future _onClickFav(BuildContext context, movie) async {
    final db = MovieDB.getInstance();

    final exists = await db.exists(movie);

    if (exists) {
      db.deleteMovie(movie.id);
      fav = false;
    } else {
      int id = await db.saveMovie(movie);
      fav = true;
      print("Filme salvo! $id");
    }
  }
}
