import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes/entity/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserClient {
  static final String baseUrl =
      'https://floralwhite-elephant-198508.hostingersite.com';
  static final String apiPath = '/api';

  static Future<bool> registerEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/register/email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to register email: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/register/data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': user.first_name,
          'last_name': user.last_name,
          'email': user.email,
          'password': user.password,
          'no_telp': user.no_telp,
          'gender': user.gender,
          'tanggal_lahir': user.tanggal_lahir,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to register: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == true) {
          String token = data['data']['token'];
          int idUser = data['data']['user']['id_user'];

          await saveToken(token);
          await saveIdUser(idUser);

          return User.fromRawJson(json.encode(data['data']['user']), token);
        } else {
          throw Exception('Invalid credentials');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<User?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiPath/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return User.fromRawJson(json.encode(data['data']), token);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<bool> updateProfileWithImage(
      String token,
      String first_name,
      String last_name,
      String no_telp,
      String gender,
      String tanggal_lahir,
      XFile? profilePicture) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$apiPath/user/profile'),
    );

    request.fields['first_name'] = first_name;
    request.fields['last_name'] = last_name;
    request.fields['no_telp'] = no_telp;
    request.fields['gender'] = gender;
    request.fields['tanggal_lahir'] = tanggal_lahir;

    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        profilePicture.path,
      ));
    }

    request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to update profile: ${response.statusCode} $responseBody');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<String?> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return "Logout Success";
      } else if (response.statusCode == 401) {
        return "Unauthorized: Please log in again.";
      } else {
        return "Failed to logout: ${response.body}";
      }
    } catch (e) {
      print('Error: $e');
      return "An error occurred while logging out.";
    }
  }

  static Future<bool> changePassword(
      String token, String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/user/changePassword'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'password': oldPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Asumsikan jika 200 berarti success
        return true;
      } else {
        // Cetak pesan error dari server untuk debugging
        print('Failed to change password: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error changing password: $e');
      return false;
    }
  }

  static Future<bool> resetPassword(String otpToken, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath/user/reset-password'),
        headers: {
          'Authorization': 'Bearer $otpToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to reset password: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error resetting password: $e');
      return false;
    }
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> saveIdUser(int idUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id_user', idUser);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("Token retrieved: $token");
    return token;
  }
}
