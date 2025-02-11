import 'dart:convert';

class Pembayaran {
  int id_pembayaran;
  int id_transaksi;
  String metode_pembayaran;
  DateTime waktu_pembayaran;

  Pembayaran({
    required this.id_pembayaran,
    required this.id_transaksi,
    required this.metode_pembayaran,
    required this.waktu_pembayaran,
  });

  factory Pembayaran.fromRawJson(String str) =>
      Pembayaran.fromJson(json.decode(str));
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
        id_pembayaran: json["id_pembayaran"],
        id_transaksi: json["id_transaksi"],
        metode_pembayaran: json["metode_pembayaran"],
        waktu_pembayaran: DateTime.parse(json["waktu_pembayaran"]),
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_pembayaran": id_pembayaran,
        "id_transaksi": id_transaksi,
        "metode_pembayaran": metode_pembayaran,
        "waktu_pembayaran": waktu_pembayaran.toIso8601String(),
      };
}
