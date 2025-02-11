import 'dart:convert';

class Jadwaltayang {
  int id_jadwal;
  int id_film;
  int id_studio;
  String tanggal;
  String jadwal_tayang;
  double harga;

  Jadwaltayang({
    required this.id_jadwal,
    required this.id_film,
    required this.id_studio,
    required this.tanggal,
    required this.jadwal_tayang,
    required this.harga,
  });

  factory Jadwaltayang.fromRawJson(String str) =>
      Jadwaltayang.fromJson(json.decode(str));
  factory Jadwaltayang.fromJson(Map<String, dynamic> json) => Jadwaltayang(
        id_jadwal: json["id_jadwal"],
        id_film: json["id_film"],
        id_studio: json["id_studio"],
        tanggal: json["tanggal"],
        jadwal_tayang: json["jadwal_tayang"],
        harga: json["harga"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_jadwal": id_jadwal,
        "id_film": id_film,
        "id_studio": id_studio,
        "tanggal": tanggal,
        "jadwal_tayang": jadwal_tayang,
        "harga": harga,
      };
}
