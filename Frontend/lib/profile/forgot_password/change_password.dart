import 'package:flutter/material.dart';
import 'package:tubes/client/UserClient.dart';
import 'package:tubes/profile/profile.dart';

class ForgotPasswordChangePage extends StatefulWidget {
  final String oldPassword;

  const ForgotPasswordChangePage({Key? key, required this.oldPassword})
      : super(key: key);

  @override
  State<ForgotPasswordChangePage> createState() =>
      _ForgotPasswordChangePageState();
}

class _ForgotPasswordChangePageState extends State<ForgotPasswordChangePage> {
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late Size mediaSize;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 20.0),
              child: _buildTop(),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Bold',
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildGreyText("New Password"),
          _buildPasswordField(newPasswordController, "Enter a new password",
              isNewPasswordVisible, () {
            setState(() {
              isNewPasswordVisible = !isNewPasswordVisible;
            });
          }),
          const SizedBox(height: 20),
          _buildGreyText("Confirm New Password"),
          _buildPasswordField(confirmPasswordController,
              "Re-enter the new password", isConfirmPasswordVisible, () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          }),
          const SizedBox(height: 30),
          _buildContinueButton(),
          const SizedBox(height: 150),
          const SizedBox(height: 150),
        ],
      ),
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

  Widget _buildPasswordField(TextEditingController controller, String hintText,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
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
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () async {
        String newPassword = newPasswordController.text.trim();
        String confirmPassword = confirmPasswordController.text.trim();

        // Validasi input
        if (newPassword.isEmpty || confirmPassword.isEmpty) {
          _showSnackBar("All fields are required.");
          return;
        }

        if (newPassword != confirmPassword) {
          _showSnackBar("New password and confirmation do not match.");
          return;
        }

        try {
          String? token = await UserClient.getToken();
          if (token == null) {
            _showSnackBar("User not logged in. Please log in first.");
            return;
          }

          bool success = await UserClient.changePassword(
              token, widget.oldPassword, newPassword);
          if (success) {
            _showSnackBar("Password reset successfully.", success: true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          } else {
            _showSnackBar("Failed to reset password.");
          }
        } catch (e) {
          _showSnackBar("An error occurred: $e");
        }
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
        "RESET PASSWORD",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins-SemiBold',
          fontSize: 16,
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
