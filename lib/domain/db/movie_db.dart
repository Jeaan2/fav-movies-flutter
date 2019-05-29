import 'dart:async';
import 'package:fav_movies/domain/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieDB {
  static final MovieDB _instance = new MovieDB.getInstance();

  factory MovieDB() => _instance;

  MovieDB.getInstance();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'movies.db');
    print("db $path");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE movie(id INTEGER PRIMARY KEY, title TEXT, backdrop_path TEXT, poster_path TEXT,'
        'overview TEXT, release_date TEXT)');
  }

  Future<int> saveMovie(Movie movie) async {
    var dbClient = await db;
    final sql =
        'insert or replace into movie (id,title,backdrop_path,poster_path,overview, release_date) VALUES '
        '(?,?,?,?,?,?)';
    print(sql);
    var id = await dbClient.rawInsert(sql, [
      movie.id,
      movie.title,
      movie.pathBackdrop,
      movie.pathPoster,
      movie.overview,
      movie.releaseDate
    ]);
    print('id: $id');
    print('movie: $movie');
    return id;
  }

  Future<List<Movie>> getAllMovies() async {
    final dbClient = await db;

    final result = await dbClient.rawQuery('select * from movie');
    final movies = result.map<Movie>((json) => Movie.fromJson(json)).toList();
    return movies;
  }

  Future<int> getCount() async {
    final dbClient = await db;
    final result = await dbClient.rawQuery('select count(*) from movie');
    return Sqflite.firstIntValue(result);
  }

  Future<Movie> getMovie(int id) async {
    var dbClient = await db;

    final result =
        await dbClient.rawQuery('select * from movie where id= ?', [id]);

    if (result.length > 0) {
      return new Movie.fromJson(result.first);
    }

    return null;
  }

  Future<bool> exists(Movie movie) async {
    Movie m = await getMovie(movie.id);
    var exists = m != null;
    return exists;
  }

  Future<int> deleteMovie(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from movie where id = ?', [id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
