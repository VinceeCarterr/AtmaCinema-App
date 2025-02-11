import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/entity/User.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../client/UserClient.dart';

enum Gender { Male, Female }

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isPasswordVisible = false;
  late Size mediaSize;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  Gender? _selectedGender;
  String? profilePicturePath;
  String? _token;
  User? user;
  String userPic = "";
  bool remove = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _initFormData() async {
    //Mengisi form dengan data user yang sekarang aktif
    nameController.text = user?.first_name ?? '';
    lastNameController.text = user?.last_name ?? '';
    phoneController.text = user?.no_telp ?? '';
    dobController.text = user?.tanggal_lahir ?? '';
    userPic = user?.profile_picture ?? '';
    setState(() {
      _selectedGender = user?.gender == 'Male' ? Gender.Male : Gender.Female;
    });
    print(_selectedGender);
  }

  _loadUserData() async {
    _token = await UserClient.getToken(); // Mendapatkan token pengguna

    if (_token != null) {
      // Ambil data profil menggunakan UserClient
      user = await UserClient.getProfile(_token!);
      if (user != null) {
        print("Success load user data");
        _initFormData();
      } else {
        // Handle error, jika data gagal diambil
        print('Failed to load user data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // Struktur utama
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfilePicture(context),
                  const SizedBox(height: 30),
                  _buildInputField("First Name", nameController),
                  const SizedBox(height: 20),
                  _buildInputField("Last Name", lastNameController),
                  const SizedBox(height: 20),
                  _buildInputField("Phone Number", phoneController,
                      isPhone: true),
                  const SizedBox(height: 20),
                  _buildDobField(dobController),
                  const SizedBox(height: 20),
                  _buildGenderField(),
                  const SizedBox(height: 30),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          //Memasukkan gambar untuk profile picture
          backgroundImage: profilePicturePath != null
          //Jika user sudah memasukkan gambar baru, gambar tsb dimasukkan
              ? FileImage(File(profilePicturePath!))
          //Jika belum, yang ditampilkan adalah gambar yang ada di database
              : remove ? NetworkImage("https://floralwhite-elephant-198508.hostingersite.com/storage/app/public/profile_pictures/default-profile.jpg") : NetworkImage("https://floralwhite-elephant-198508.hostingersite.com/storage/app/public/" + userPic),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                _showProfilePictureOptions(context);
              },
              icon: const Icon(Icons.edit, size: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showProfilePictureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Pilihan 1: Ambil gambar dari kamera
              ListTile(
                title: const Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context);
                  //Memanggil page camera dan returnkan path dari gambar yang baru difoto
                  final imagePath =
                      await Navigator.pushNamed(context, '/camera');
                  if (imagePath != null && mounted) {
                    setState(() {
                      profilePicturePath = imagePath as String;
                    });
                  }
                },
              ),
              //Pilihan 1: Ambil gambar dari galeri
              ListTile(
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _openGallery();
                },
              ),
              //Pilihan 1: Menghilangkan profile picture
              ListTile(
                title: const Text('Remove Profile Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfilePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      setState(() {
        profilePicturePath = image.path;
      });
    }
  }

  void _removeProfilePicture() {
    setState(() {
      profilePicturePath = null;
      remove = true;
    });
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPhone = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDobField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date of Birth",
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.grey),
          onPressed: () {
            _selectDate(context, controller);
          },
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.Male,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text("Male", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.Female,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const Text("Female", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        String? token = await UserClient.getToken();
        User? user = await UserClient.getProfile(token!);
        if (token != null) {
          bool success = await UserClient.updateProfileWithImage(
            token,
            nameController.text,
            lastNameController.text,
            phoneController.text,
            _selectedGender?.toString().split('.').last ?? '',
            dobController.text,
            profilePicturePath != null ? XFile(profilePicturePath!) : null,
          );

          if (success) {
            final overlay = Overlay.of(context);
            final overlayEntry = OverlayEntry(
              builder: (context) => Positioned(
                top: 50.0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: AwesomeSnackbarContent(
                    title: 'Update Success',
                    message: 'Profile updated successfully!',
                    contentType: ContentType.success,
                    inMaterialBanner: true,
                  ),
                ),
              ),
            );

            overlay.insert(overlayEntry);

            Future.delayed(Duration(seconds: 3), () {
              overlayEntry.remove();
            });

            Navigator.pop(context, true);
          } else {
            final overlay = Overlay.of(context);
            final overlayEntry = OverlayEntry(
              builder: (context) => Positioned(
                top: 50.0, // You can adjust the position here
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: AwesomeSnackbarContent(
                    title: 'Update Profile Failed',
                    message: 'Failed to update profile. Please try again.',
                    contentType: ContentType.failure,
                    inMaterialBanner: true,
                  ),
                ),
              ),
            );

            overlay.insert(overlayEntry);

            Future.delayed(Duration(seconds: 3), () {
              overlayEntry.remove();
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white24,
      ),
      child: const Text(
        'Update Profile',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', nameController.text);
    await prefs.setString('last_name', lastNameController.text);
    await prefs.setString('phone_number', phoneController.text);
    await prefs.setString('dob', dobController.text);
    await prefs.setString(
        'gender', _selectedGender == Gender.Male ? 'Male' : 'Female');
    await prefs.setString('profile_picture', profilePicturePath ?? "");
  }

  bool _isValidInput() {
    return nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        _selectedGender != null;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Changes"),
          content: const Text("Are you sure you want to save the changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _saveUserData();
                Navigator.pop(context);
                _showSuccessDialog();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Profile updated successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
