import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tubes/entity/JadwalTayang.dart';

class JadwaltayangClient {
  static const String _baseUrl =
      'https://floralwhite-elephant-198508.hostingersite.com';
  static const String _endpoint = '/api/jadwal_tayang';

  static Future<List<Jadwaltayang>> fetchAllJadwal(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch Jadwal: ${response.reasonPhrase}');
      }

      Iterable jsonList = json.decode(response.body)['data'];

      return jsonList.map((data) => Jadwaltayang.fromJson(data)).toList();
    } catch (e) {
      return Future.error('Error fetching JadwalTayang: $e');
    }
  }
}
