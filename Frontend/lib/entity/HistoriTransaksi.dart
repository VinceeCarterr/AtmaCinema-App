import 'dart:convert';

class Historitransaksi {
  int id_histori;
  int id_user;
  int id_transaksi;

  Historitransaksi({
    required this.id_histori,
    required this.id_user,
    required this.id_transaksi,
  });

  factory Historitransaksi.fromRawJson(String str) =>
      Historitransaksi.fromJson(json.decode(str));
  factory Historitransaksi.fromJson(Map<String, dynamic> json) =>
      Historitransaksi(
        id_histori: json["id_histori"],
        id_user: json["id_user"],
        id_transaksi: json["id_transaksi"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_histori": id_histori,
        "id_user": id_user,
        "id_transaksi": id_transaksi,
      };
}
