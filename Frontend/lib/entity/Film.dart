import 'dart:convert';

class Film {
  int id_film;
  String judul_film;
  int durasi;
  String rating_umur;
  String dimensi;
  String tanggal_rilis;
  String genre;
  String sinopsis;
  String producer;
  String director;
  String writers;
  String cast;
  String poster;
  String status;
  double? rating;

  Film({
    required this.id_film,
    required this.judul_film,
    required this.durasi,
    required this.rating_umur,
    required this.dimensi,
    required this.tanggal_rilis,
    required this.genre,
    required this.sinopsis,
    required this.producer,
    required this.director,
    required this.writers,
    required this.cast,
    required this.poster,
    required this.status,
    this.rating,
  });

  factory Film.fromRawJson(String str) => Film.fromJson(json.decode(str));
  factory Film.fromJson(Map<String, dynamic> json) => Film(
        id_film: json["id_film"],
        judul_film: json["judul_film"],
        durasi: json["durasi"],
        rating_umur: json["rating_umur"],
        dimensi: json["dimensi"],
        tanggal_rilis: json["tanggal_rilis"],
        genre: json["genre"],
        sinopsis: json["sinopsis"],
        producer: json["producer"],
        director: json["director"],
        writers: json["writers"],
        cast: json["cast"],
        poster: json["poster"],
        status: json["status"],
        rating: json["reviews_avg_rating_review"] != null
            ? double.tryParse(json["reviews_avg_rating_review"].toString())
            : null,
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_film": id_film,
        "judul_film": judul_film,
        "durasi": durasi,
        "rating_umur": rating_umur,
        "dimensi": dimensi,
        "tanggal_rilis": tanggal_rilis,
        "genre": genre,
        "sinopsis": sinopsis,
        "producer": producer,
        "director": director,
        "writers": writers,
        "cast": cast,
        "poster": poster,
        "status": status,
        "rating": rating,
      };
}
