import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/entity/User.dart';
import 'package:tubes/profile/edit_profile.dart';
import 'package:tubes/login/login.dart';
import 'package:tubes/profile/change_password.dart';

import 'package:tubes/client/UserClient.dart';
import 'package:tubes/entity/User.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? dob;
  String? token; // Menyimpan token untuk autentikasi
  String? profilePicturePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna, mengambil token dan request data dari API
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Mendapatkan token pengguna

    if (token != null) {
      // Ambil data profil menggunakan UserClient
      User? user = await UserClient.getProfile(token!);
      if (user != null) {
        // Mengisi data pengguna ke variabel state dari data yang didapat (database)
        setState(() {
          fullName = user.first_name + ' ' + user.last_name;
          email = user.email;
          phoneNumber = user.no_telp;
          gender = user.gender;
          dob = user.tanggal_lahir;
          profilePicturePath = user.profile_picture;
        });
      } else {
        // Handle error, jika data gagal diambil
        print('Failed to load user data');
      }
    } else {
      // Jika token tidak ditemukan, alihkan ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<String?> _fetchProfilePicture() async {
    //Tunggu 2 detik
    await Future.delayed(const Duration(seconds: 2));

    return profilePicturePath!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String?>(
                future: _fetchProfilePicture(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Munculkan animasi loading sambil nunggu gambar
                    return const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    //Kalo error
                    return const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.error, size: 50, color: Colors.black),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    //Menampilkan gambar kalau path ditemukan
                    print("\t\t ${snapshot.data}");
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://floralwhite-elephant-198508.hostingersite.com/storage/app/public/" + snapshot.data!),
                    );
                  } else {
                    //Jika tidak ada profule picture, tampilkan icon default
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                              'assets/images/blank-profile-picture.jpg')
                          as ImageProvider,
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.black),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                fullName ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildProfileDetails(),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileDetail('Email', email),
          _buildProfileDetail('Phone Number', phoneNumber),
          _buildProfileDetail('Date of Birth', dob),
          _buildProfileDetail('Gender', gender),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? '-',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildProfileButton(
          icon: Icons.edit,
          label: 'Edit Profile',
          color: Colors.grey[850],
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
            if (result != null && result == true) {
              setState(() {
                _loadUserData();
              });
            }
          },
        ),
        const SizedBox(height: 10),
        _buildProfileButton(
          icon: Icons.lock,
          label: 'Change Password',
          color: Colors.grey[850],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage()),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildProfileButton(
          icon: Icons.logout,
          label: 'Logout',
          color: Colors.grey[850],
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('token'); // Ambil token pengguna

            if (token != null) {
              // Panggil fungsi logout untuk mengirimkan request ke server
              String? logoutMessage = await UserClient.logout(token);

              if (logoutMessage == "Logout Success") {
                // Hapus token dari SharedPreferences
                prefs.remove('token');

                // Arahkan pengguna ke halaman login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                // Tampilkan pesan error jika gagal logout
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(logoutMessage ?? 'Unknown error')),
                );
              }
            } else {
              print('No token found');
              // Tampilkan pesan jika token tidak ditemukan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Token not found, please log in again')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileButton({
    required IconData icon,
    required String label,
    required Color? color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
