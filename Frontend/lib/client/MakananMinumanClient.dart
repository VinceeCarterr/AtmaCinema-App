import 'dart:convert';
import 'package:http/http.dart';
import 'package:tubes/entity/MakananMinuman.dart';

class MakananMinumanClient {
  static final String baseUrl =
      'https://floralwhite-elephant-198508.hostingersite.com';
  static final String endpoint = '/api/makanan_minuman';

  static Future<List<Makananminuman>> fetchByKategori(
      String kategori, String token) async {
    try {
      final response = await get(
        Uri.parse('$baseUrl$endpoint/kategori/$kategori'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch by kategori: ${response.reasonPhrase}');
      }

      final decodedResponse = json.decode(response.body);
      print(decodedResponse);

      Iterable list = decodedResponse['data'];
      return list.map((e) => Makananminuman.fromJson(e)).toList();
    } catch (e) {
      return Future.error('Error fetching by kategori: $e');
    }
  }

  static Future<Makananminuman> find(int id) async {
    try {
      final response = await get(Uri.parse('$baseUrl$endpoint/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to find item: ${response.reasonPhrase}');
      }

      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];

      return Makananminuman.fromJson(data);
    } catch (e) {
      return Future.error('Error finding item: $e');
    }
  }

  static Future<List<Makananminuman>> search(
      String query, String kategori, String token) async {
    try {
      final response = await get(
        Uri.parse('$baseUrl$endpoint/search?query=$query&category=$kategori'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to search items: ${response.reasonPhrase}');
      }

      final decodedResponse = json.decode(response.body);
      print("Response:");
      print(decodedResponse);

      List<Makananminuman> items = decodedResponse.map<Makananminuman>((e) {
        return Makananminuman.fromJson(e);
      }).toList();

      return items;
    } catch (e) {
      return Future.error('Error searching items: $e');
    }
  }
}
