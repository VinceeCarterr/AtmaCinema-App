import 'package:flutter/material.dart';
import 'package:tubes/login/login.dart';
import 'package:tubes/register/register_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/client/UserClient.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    myColor = Colors.black;
    mediaSize = MediaQuery.of(context).size;

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
              MaterialPageRoute(builder: (context) => const LoginPage()),
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Register Account",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-SemiBold',
                fontSize: 32,
              ),
            ),
            const Text(
              "Enjoy Movie With Us",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Light',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _buildGreyText("Email Address"),
            const SizedBox(height: 5),
            _emailInput(emailController),
            const SizedBox(height: 40),
            _buildContinueButton(),
            const SizedBox(height: 300),
            _buildLoginLink(),
            const SizedBox(height: 20),
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

  Widget _emailInput(TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-Regular',
        ),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter your email',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins-Light',
          ),
          suffixIcon: const Icon(Icons.email, color: Colors.white70),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email cannot be empty';
          } else if (!value.contains('@')) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final email = emailController.text;
          bool success = await UserClient.registerEmail(email);

          if (success) {
            // Menyimpan email dalam lokal buat digunakan di halaman selanjutnya
            await _saveUserData();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterOTPPage()),
            );
          } else {
            // Nampilken pesen nek email wis didaftari
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Email already registered or invalid.')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Colors.white,
        elevation: 20,
        shadowColor: Colors.white30,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text(
        "CONTINUE",
        style: TextStyle(
            color: Colors.black, fontFamily: 'Poppins-SemiBold', fontSize: 16),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Already have any account? ",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Login",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
  }
}
