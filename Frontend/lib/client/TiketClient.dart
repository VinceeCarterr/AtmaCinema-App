import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tubes/entity/Tiket.dart';
import 'package:tubes/entity/JadwalTayang.dart';
import 'FilmClient.dart';
import 'JadwalTayangClient.dart';

class TiketClient {
  // Update the base URL
  static const String _baseUrl = 'https://floralwhite-elephant-198508.hostingersite.com';
  static const String _endpoint = '/api/tiket';

  /// Fetch tickets by user ID and include related film data
  static Future<List<Tiket>> fetchTicketsByUser(int userId, String token) async {
    try {
      final response = await get(
        Uri.parse('$_baseUrl$_endpoint/user/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Add this line here to inspect the raw JSON coming from the server
      print("Raw API Response: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch tickets: ${response.reasonPhrase}');
      }

      Iterable jsonList = json.decode(response.body)['data'];
      print("Parsed Tickets JSON List: $jsonList");

      List<Tiket> tickets = jsonList.map((data) {
        print("Mapping ticket data: $data");
        print("jadwal_tayang: ${data["jadwal_tayang"]}");
        print("film object: ${data["jadwal_tayang"]?["film"]}");
        print("judul_film: ${data["jadwal_tayang"]?["film"]?["judul_film"]}");
        return Tiket.fromJson(data);
      }).toList();

      return tickets;
    } catch (e) {
      return Future.error('Error fetching tickets: $e');
    }
  }

  static Future<Tiket> find(int id, String token) async {
    try {
      final response = await http.get(
        Uri.https(_baseUrl, '$_endpoint/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch ticket: ${response.reasonPhrase}');
      }

      final jsonData = json.decode(response.body)['data'];
      Tiket tiket = Tiket.fromJson(jsonData);

      // Fetch related JadwalTayang and Film data
      var jadwalTayangData = jsonData['jadwal_tayang'];
      if (jadwalTayangData != null) {
        tiket.jamTayang = jadwalTayangData['jam_tayang'];
        tiket.tanggal = jadwalTayangData['tanggal'];

        // Fetch related Film data
        var filmData = jadwalTayangData['film'];
        if (filmData != null) {
          tiket.judulFilm = filmData['judul_film'];
          tiket.poster = filmData['poster'];
          tiket.format = filmData['dimensi'];
        }
      }

      // Default film duration to 120 minutes (2 hours)
      int filmDuration = 120;
      DateTime jamTayang = DateTime.parse(tiket.jamTayang!);
      DateTime endTime = jamTayang.add(Duration(minutes: filmDuration));

      // Calculate and assign the status
      tiket.status =
          DateTime.now().isBefore(endTime) ? "on progress" : "history";

      return tiket;
    } catch (e) {
      return Future.error('Error fetching ticket: $e');
    }
  }

  /// Create a new ticket
  static Future<Tiket> create(Map<String, dynamic> tiketData, String? token) async {
    try {
      print("Sending POST request to: $_baseUrl$_endpoint");
      print("Headers: {Content-Type: application/json, Authorization: Bearer $token}");
      print("Body: ${json.encode(tiketData)}");

      final response = await post(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(tiketData),
      );

      // Check for a successful response
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create ticket: ${response.reasonPhrase}');
      }

      // Parse the response body
      var responseBody = json.decode(response.body);

      // Check if 'data' exists in the response body
      if (responseBody.containsKey('data') && responseBody['data'] != null) {
        var jsonData = responseBody['data'];

        print("Ticket Data: $jsonData");
        return Tiket.fromJson(jsonData);
      } else {
        throw Exception('Missing data in response');
      }
    } catch (e) {
      return Future.error('Error creating ticket: $e');
    }
  }


  /// Update an existing ticket by ID
  static Future<Tiket> update(
      int id, Map<String, dynamic> tiketData, String token) async {
    try {
      final response = await http.put(
        Uri.https(_baseUrl, '$_endpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(tiketData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update ticket: ${response.reasonPhrase}');
      }

      final jsonData = json.decode(response.body)['data'];
      return Tiket.fromJson(jsonData);
    } catch (e) {
      return Future.error('Error updating ticket: $e');
    }
  }

  /// Delete a ticket by ID
  static Future<void> delete(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.https(_baseUrl, '$_endpoint/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete ticket: ${response.reasonPhrase}');
      }
    } catch (e) {
      return Future.error('Error deleting ticket: $e');
    }
  }
}
