import 'package:flutter/material.dart';
import 'package:tubes/login/login.dart';
import 'package:tubes/register/register_email.dart';
import 'package:tubes/register/register_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/client/UserClient.dart';

class RegisterOTPPage extends StatefulWidget {
  const RegisterOTPPage({super.key});

  @override
  State<RegisterOTPPage> createState() => _RegisterOTPPageState();
}

class _RegisterOTPPageState extends State<RegisterOTPPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Color myColor;
  late Size mediaSize;
  TextEditingController otpController = TextEditingController();
  String? email;

  @override
  void initState() {
    super.initState();
    _loadEmailFromPrefs(); // Memuat email dari SharedPreferences
  }

  Future<void> _loadEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email'); // Ambil email dari SharedPreferences
    });
    if (email == null) {
      // Jika email tidak ditemukan, arahkan kembali ke RegisterEmail atau tampilkan pesan error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    }
  }

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
              MaterialPageRoute(builder: (context) => const RegisterPage()),
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
            child: _buildInputOTP(),
          ),
        ),
      ),
    );
  }

  Widget _buildInputOTP() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email Verification",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-SemiBold',
                fontSize: 32,
              ),
            ),
            const Text(
              "We’ve sent a verification code to your email",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Light',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _buildGreyText("OTP Code"),
            const SizedBox(height: 5),
            _otpInput(otpController),
            const SizedBox(height: 40),
            _buildVerifyButton(),
            const SizedBox(height: 20),
            _buildResendOTP(),
            const SizedBox(height: 230),
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

  Widget _otpInput(TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-Regular',
        ),
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter OTP code',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins-Light',
          ),
          suffixIcon: const Icon(Icons.lock, color: Colors.white70),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'OTP cannot be empty';
          } else if (value.length != 6) {
            return 'OTP must be 6 digits';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("OTP : ${otpController.text}");
        if (_formKey.currentState!.validate()) {
          await _saveOTPData();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterData()),
          );
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
        "VERIFY",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins-SemiBold',
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildResendOTP() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Implementasi resend OTP
        },
        child: RichText(
          text: TextSpan(
            text: "Didn’t receive code? ",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Resend Code",
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
            text: "Already have an account? ",
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

  Future<void> _saveOTPData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'otp', otpController.text); // Simpan OTP kalau mau dipakai nanti
  }
}
