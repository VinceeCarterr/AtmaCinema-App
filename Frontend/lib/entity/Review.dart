import 'dart:convert';

class Review {
  int? id_review;
  int id_film;
  String full_name;
  int rating_review;
  String? deskripsi_review;
  String? review_at;
  String? poster;

  Review({
    this.id_review,
    required this.id_film,
    required this.full_name,
    required this.rating_review,
    this.deskripsi_review,
    this.review_at,
    required this.poster,
  });

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id_review: json["id_review"],
        id_film: json["id_film"],
        full_name: json["full_name"],
        rating_review: json["rating_review"],
        deskripsi_review: json["deskripsi_review"],
        review_at: json["review_at"],
        poster: json["poster"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_review": id_review,
        "id_film": id_film,
        "full_name": full_name,
        "rating_review": rating_review,
        "deskripsi_review": deskripsi_review,
        "review_at": review_at,
        "poster": poster,
      };
}

class ResponseReview {
  String average;
  int totalRating;
  int? totalDescription;
  List<Review>? reviews;

  ResponseReview({
    required this.average,
    required this.totalRating,
    this.totalDescription,
    this.reviews,
  });

  factory ResponseReview.fromRawJson(String str) =>
      ResponseReview.fromJson(json.decode(str));

  factory ResponseReview.fromJson(Map<String, dynamic> json) => ResponseReview(
        average: json["average"],
        totalRating: json["total_rating"],
        totalDescription: json["total_descriptions"],
        reviews: List<Review>.from(
          json["reviews"].map((x) => Review.fromJson(x)),
        ),
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "average": average,
        "total_rating": totalRating,
        "total_descriptions": totalDescription,
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}
