class Movie {

  String? id;
  final String title;
  final String year;
  final String director;
  final String genre;
  final String synopsis;
  final String image;

  Movie({
    this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.image,
  });

  factory Movie.fromMap(Map<String, dynamic> map, String id) {
    return Movie(
      id: id,
      title: map['title'] ?? '',
      year: map['year'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      synopsis: map['synopsis'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'image': image,
    };
  }
}