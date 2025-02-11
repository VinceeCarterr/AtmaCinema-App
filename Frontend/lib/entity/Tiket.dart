import 'dart:convert';
import 'package:tubes/entity/Film.dart';

class Tiket {
  int? id_tiket;
  int id_transaksi;
  int id_jadwal;
  int jumlah_kursi;
  String? status;
  int id_user;
  String? jamTayang;
  String? tanggal;
  String? judulFilm;
  String? poster;
  String? format;
  int? noStudio;
  int? id_film;
  Film? film;
  double? harga;

  Tiket({
    this.id_tiket,
    required this.id_transaksi,
    required this.id_jadwal,
    required this.jumlah_kursi,
    this.status,
    required this.id_user,
    this.jamTayang,
    this.tanggal,
    this.judulFilm,
    this.poster,
    this.format,
    this.noStudio,
    this.id_film,
    this.film,
    this.harga,
  });

  factory Tiket.fromRawJson(String str) => Tiket.fromJson(json.decode(str));

  factory Tiket.fromJson(Map<String, dynamic> json) => Tiket(
        id_tiket: json["id_tiket"],
        id_transaksi: json["id_transaksi"],
        id_jadwal: json["id_jadwal"],
        jumlah_kursi: json["jumlah_kursi"],
        id_user: json["id_user"],
        jamTayang: json["jadwal_tayang"]?["jam_tayang"],
        tanggal: json["jadwal_tayang"]?["tanggal"],
        judulFilm: json["jadwal_tayang"]?["film"]?["judul_film"],
        poster: json["jadwal_tayang"]?["film"]?["poster"],
        format: json["jadwal_tayang"]?["film"]?["dimensi"],
        noStudio: json["jadwal_tayang"]?["studio"]?["nomor_studio"],
        id_film: json["jadwal_tayang"]?["id_film"],
        // film: Film.fromJson(json["jadwal_tayang"]["film"]),
        harga: json["jadwal_tayang"]?["harga"] != null
            ? double.tryParse(json["jadwal_tayang"]["harga"].toString())
            : null,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_tiket": id_tiket,
        "id_transaksi": id_transaksi,
        "id_jadwal": id_jadwal,
        "jumlah_kursi": jumlah_kursi,
        "status": status,
        "id_user": id_user,
        "jamTayang": jamTayang,
        "tanggal": tanggal,
        "judulFilm": judulFilm,
        "poster": poster,
        "format": format,
        "noStudio": noStudio,
        "id_film": id_film,
        "harga": harga
      };

  void updateStatus() {
    if (jamTayang != null && tanggal != null) {
      try {
        final dateParts = tanggal!.split('-');
        if (dateParts.length == 3) {
          final reformattedDate =
              '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
          final reformattedTime =
              jamTayang!.contains(':') && jamTayang!.length == 5
                  ? '$jamTayang:00'
                  : jamTayang;
          final DateTime scheduledTime =
              DateTime.parse('$reformattedDate $reformattedTime');
          final DateTime now = DateTime.now();
          status = now.isAfter(scheduledTime.add(Duration(hours: 2)))
              ? "history"
              : "on progress";
        } else {
          print("Invalid date format for Ticket ID $id_tiket: $tanggal");
        }
      } catch (e) {
        print("Error in updateStatus for Ticket ID $id_tiket: $e");
      }
    } else {
      print(
          "Missing data for Ticket ID $id_tiket: tanggal or jamTayang is null");
    }
  }
}
