import 'dart:convert';

class Transaksi {
  int? id_transaksi;
  int id_user;
  double total_harga;
  bool status;

  Transaksi({
    this.id_transaksi,
    required this.id_user,
    required this.total_harga,
    required this.status,
  });

  factory Transaksi.fromRawJson(String str) =>
      Transaksi.fromJson(json.decode(str));
  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        id_transaksi: json["id_transaksi"],
        id_user: json["id_user"],
        total_harga: json["total_harga"],
        status: json["status"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_transaksi": id_transaksi,
        "id_user": id_user,
        "total_harga": total_harga,
        "status": status,
      };
}
