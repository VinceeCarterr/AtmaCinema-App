import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/login/login.dart';
import 'package:tubes/register/register_otp.dart';
import 'package:tubes/client/UserClient.dart';
import 'package:tubes/entity/User.dart';

enum Gender { man, female }

class RegisterData extends StatefulWidget {
  const RegisterData({super.key});

  @override
  State<RegisterData> createState() => _RegisterDataState();
}

class _RegisterDataState extends State<RegisterData> {
  bool isPasswordVisible = false;
  late Color myColor;
  late Size mediaSize;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  Gender? _selectedGender;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Mengambil email dari shared preferences
  }

  // Method untuk mengambil email dari shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      isLoading = false;
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.green,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    myColor = Colors.black;
    mediaSize = MediaQuery.of(context).size;

    // Menampilkan loading spinner jika data sedang dimuat
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Misale nek email e kosong, bakal nampilkeun pesan error
    if (email == null) {
      return Scaffold(
        body: Center(child: Text('Email not found in shared preferences')),
      );
    }

    return Container(
      decoration: BoxDecoration(color: myColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 5.0),
              child: _buildTop(),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterOTPPage()),
            );
          },
        ),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "ATMA ",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-Bold',
                  fontSize: 28,
                ),
              ),
              TextSpan(
                text: "Cinema",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-Regular',
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottom() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: SizedBox(
        width: mediaSize.width,
        child: Card(
          color: const Color(0xFF0A2038),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildInputRegister(),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRegister() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Information",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-SemiBold',
                fontSize: 32,
              ),
            ),
            const Text(
              "Please input your information",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Light',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            _buildGreyText("First Name"),
            _buildFirstNameField(firstNameController),
            const SizedBox(height: 20),
            _buildGreyText("Last Name"),
            _buildLastNameField(lastNameController),
            const SizedBox(height: 20),
            _buildGreyText("Password"),
            _buildPasswordField(passwordController),
            const SizedBox(height: 20),
            _buildGreyText("Phone Number"),
            _buildPhoneField(phoneController),
            const SizedBox(height: 20),
            _buildGreyText("Date of Birth"),
            _buildDobField(dobController),
            const SizedBox(height: 20),
            _buildGreyText("Gender"),
            const SizedBox(height: 10),
            _buildGenderField(),
            const SizedBox(height: 30),
            _buildRegisterButton(),
            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: 'Poppins-Regular',
      ),
    );
  }

  Widget _buildFirstNameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-Regular',
      ),
      decoration: InputDecoration(
        hintText: 'Enter first name',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: const Icon(Icons.person),
      ),
    );
  }

  Widget _buildLastNameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-Regular',
      ),
      decoration: InputDecoration(
        hintText: 'Enter last name',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: const Icon(Icons.person),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-Regular',
      ),
      decoration: InputDecoration(
        hintText: 'Enter phone number',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: const Icon(Icons.phone),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Enter password',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDobField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select your date of birth',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context, controller);
          },
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
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.man,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text(
                  'Male',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio<Gender>(
                  value: Gender.female,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text(
                  'Female',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
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
        // Melakukan validasi input
        if (firstNameController.text.isEmpty ||
            lastNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please enter both first and last name!')),
          );
          return;
        }
        if (passwordController.text.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Password must be at least 6 characters long!')),
          );
          return;
        }
        if (phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your phone number!')),
          );
          return;
        }
        if (_selectedGender == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select your gender!')),
          );
          return;
        }
        if (dobController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select your date of birth!')),
          );
          return;
        }

        // Tampilkan dialog konfirmasi
        _showConfirmationDialog(context);
      },
      child: const Text('Register'),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Registration Confirmation",
      desc: "Are You Sure Want To Register ?",
      buttons: [
        DialogButton(
          child: const Text(
            "Ya",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // Jika pengguna memilih "Ya", lanjutkan proses registrasi
            _registerUser();
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
        DialogButton(
          child: const Text(
            "Tidak",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // Jika pengguna memilih "Tidak", tutup dialog
            Navigator.pop(context);
          },
          color: Colors.red,
        ),
      ],
    ).show();
  }

  // Fungsi untuk melakukan registrasi user
  Future<void> _registerUser() async {
    final user = User(
      first_name: firstNameController.text,
      last_name: lastNameController.text,
      email: email!,
      password: passwordController.text,
      no_telp: phoneController.text,
      gender: _selectedGender == Gender.man ? 'male' : 'female',
      tanggal_lahir: dobController.text,
    );
    try {
      // Melakukan request ke API untuk register user baru dengan data yang diberikan
      bool success = await UserClient.registerUser(user);

      // Jika registrasi berhasil, alihkan ke halaman login
      if (success) {
        showToast('Registration successful!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Jika registrasi gagal, bakal nampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed!')),
        );
      }
    } catch (e) {
      // Cuma exception aja kalau Sum Ting Wong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
