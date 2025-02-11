import 'package:flutter/material.dart';
import 'package:tubes/profile/change_password.dart';
import 'package:tubes/profile/forgot_password/change_password.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController otpController = TextEditingController();
  String? otpErrorText;
  late Size mediaSize;

  // Tambahkan state untuk menentukan tampilan
  bool showResetPasswordPage = false;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: showResetPasswordPage
            ? _buildResetPasswordPage() // Tampilan Reset Password
            : _buildOTPVerificationPage(), // Tampilan OTP
      ),
    );
  }

  // Halaman OTP Verification
  Widget _buildOTPVerificationPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildBottom(),
      ],
    );
  }

  Widget _buildResetPasswordPage() {
    return ForgotPasswordChangePage(
      oldPassword: "default_password",
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Email Verification",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins-Bold',
            fontSize: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "We've sent a verification code to your email",
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins-Regular',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGreyText("Verification Code"),
        _buildTextField(otpController, "Enter your OTP"),
        const SizedBox(height: 30),
        _buildContinueButton(),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {
              // Buat resend
            },
            child: const Text(
              "Didn't receive code? Resend Code",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Regular',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 250),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontFamily: 'Poppins-Regular',
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins-Regular',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins-Light',
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorText: otpErrorText,
            errorStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Poppins-Regular',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (otpController.text.isEmpty) {
            otpErrorText = "Please enter your verification code";
          } else {
            otpErrorText = null;
            debugPrint("Entered OTP: ${otpController.text}");
            // Alihkan ke halaman reset password
            showResetPasswordPage = true;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text(
        "CONTINUE",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins-SemiBold',
          fontSize: 16,
        ),
      ),
    );
  }
}
