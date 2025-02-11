import 'package:flutter/material.dart';
import 'package:tubes/loading_screen.dart';
import 'package:tubes/login/login.dart';
import 'package:camera/camera.dart';
import 'package:tubes/profile/camera_screen.dart';
import 'package:tubes/profile/edit_profile.dart';
import 'package:tubes/home/home.dart';

import 'package:tubes/client/UserClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATMA Cinema',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/camera': (context) => CameraScreen(cameras: cameras),
      },
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          // Menunggu hasil cek login status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika token ditemukan, arahkan ke HomePage, jika tidak, ke LoginPage
          if (snapshot.hasData && snapshot.data == true) {
            return homePage(); // Arahkan ke halaman utama (HomePage)
          } else {
            return LoginPage(); // Arahkan ke halaman login (LoginPage)
          }
        },
      ),
    );
  }

  // Fungsi untuk mengecek apakah pengguna sudah login atau belum
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Cek apakah ada token yang disimpan
    return token != null; // Jika token ada, artinya sudah login
  }
}
