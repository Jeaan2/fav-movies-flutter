import 'package:fav_movies/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../movie.dart';

class MovieService {

  static List<Movie> _computeMovies(dynamic body) => List<Movie>.from(body.map((movie) => Movie.fromJson(movie)));

  static Future<List<Movie>> getMovies() async {


        var url = Uri.https(MOVIE_DB_BASE_URL, '/3/movie/upcoming',
            {
              'api_key': API_KEY,
              'language': 'pt-BR'
            });

        var response = await http.get(url);

        final body = convert.json.decode(response.body);

        return compute(_computeMovies, body['results']);
  }
}
