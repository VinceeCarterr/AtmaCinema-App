import 'dart:convert';

class Studio {
  int id_studio;
  int nomor_studio;
  int kapasitas;

  Studio({
    required this.id_studio,
    required this.nomor_studio,
    required this.kapasitas,
  });

  factory Studio.fromRawJson(String str) => Studio.fromJson(json.decode(str));
  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
        id_studio: json["id_studio"],
        nomor_studio: json["nomor_studio"],
        kapasitas: json["kapasitas"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_studio": id_studio,
        "nomor_studio": nomor_studio,
        "kapasitas": kapasitas,
      };
}
