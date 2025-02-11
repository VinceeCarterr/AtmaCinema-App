import 'dart:convert';

class Makananminuman {
  int id_makanan_minuman;
  String nama_item;
  double harga_item;
  String deskripsi_item;
  String kategori;
  String gambar;

  Makananminuman({
    required this.id_makanan_minuman,
    required this.nama_item,
    required this.harga_item,
    required this.deskripsi_item,
    required this.kategori,
    required this.gambar,
  });

  factory Makananminuman.fromRawJson(String str) =>
      Makananminuman.fromJson(json.decode(str));
  factory Makananminuman.fromJson(Map<String, dynamic> json) => Makananminuman(
        id_makanan_minuman: json["id_makanan_minuman"],
        nama_item: json["nama_item"],
        harga_item: double.tryParse(json['harga_item'].toString()) ?? 0.0,
        deskripsi_item: json["deskripsi_item"],
        kategori: json["kategori"],
        gambar: json["gambar"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_makanan_minuman": id_makanan_minuman,
        "nama_item": nama_item,
        "harga_item": harga_item,
        "deskripsi_item": deskripsi_item,
        "kategori": kategori,
        "gambar": gambar,
      };
}
