import 'package:fav_movies/domain/movie.dart';
import 'package:fav_movies/domain/services/movies_service.dart';
import 'package:flutter/material.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gridViewBody(),
    );
  }

  _gridViewBody() {

    Future<List<Movie>> movie = MovieService.getMovies();

    new FutureBuilder(
      future: movie,
      builder:
        (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Movie> movies = snapshot.data;

      return _listView(movies);
    });
  }

  _listView(List<Movie> movies) {

    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (ctx, idx) {
          final m = movies[idx];
          return Text(
          m.title
          );
        });
/*
    return List.generate(100, (index) {
      return Center(
        child: Text(
          'que merda $index',
          style: Theme
              .of(context)
              .textTheme
              .headline,
        ),
      );
    });*/
  }
}


