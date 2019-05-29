class Movie {
  final int id;
  final String title;
  final String pathBackdrop;
  final String pathPoster;
  final String overview;
  final String releaseDate;


  Movie(this.title, this.pathBackdrop, this.pathPoster, this.overview,
      this.releaseDate, this.id);

  Movie.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        pathBackdrop = map["backdrop_path"],
        pathPoster = map["poster_path"],
        overview = map["overview"],
        releaseDate = map["release_date"];

}
