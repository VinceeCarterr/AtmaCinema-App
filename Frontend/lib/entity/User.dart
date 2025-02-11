import 'dart:convert';

class User {
  int? id_user;
  String first_name;
  String last_name;
  String email;
  String password;
  String no_telp;
  String gender;
  String tanggal_lahir;
  String? profile_picture;
  String? token;

  User({
    this.id_user,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.no_telp,
    required this.gender,
    required this.tanggal_lahir,
    this.profile_picture,
    this.token,
  });

  factory User.fromRawJson(String str, String token) =>
      User.fromJson(json.decode(str), token);
  factory User.fromJson(Map<String, dynamic> json, String token) => User(
        id_user: json["id_user"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email: json["email"],
        password: json["password"],
        no_telp: json["no_telp"],
        gender: json["gender"],
        tanggal_lahir: json["tanggal_lahir"],
        profile_picture: json["profile_picture"],
        token: token,
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_user": id_user,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "password": password,
        "no_telp": no_telp,
        "gender": gender,
        "tanggal_lahir": tanggal_lahir,
        "profile_picture": profile_picture,
        "token": token,
      };
}
