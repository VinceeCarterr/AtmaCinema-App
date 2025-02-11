import 'package:flutter/material.dart';
import 'package:tubes/home/home.dart';
import 'package:tubes/register/register_email.dart';

import 'package:tubes/client/UserClient.dart';
import 'package:tubes/entity/User.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Colors.white12;
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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

  void errorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.red,
      fontSize: 16.0,
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
          children: [
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
            padding: const EdgeInsets.all(15.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText("Welcome"),
          _buildWhiteText("Please login with your account"),
          const SizedBox(height: 50),
          _buildGreyText("Email Address"),
          const SizedBox(height: 5),
          _buildInputField(emailController),
          const SizedBox(height: 20),
          _buildGreyText("Password"),
          _buildPasswordField(passwordController),
          const SizedBox(height: 20),
          _buildRememberForgot(),
          const SizedBox(height: 20),
          _buildLoginButton(),
          const SizedBox(height: 30),
          _buildOtherLogin(),
          const SizedBox(height: 20),
          _buildRegisterLink(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-SemiBold',
        fontSize: 32,
      ),
    );
  }

  Widget _buildWhiteText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-Light',
        fontSize: 16,
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

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins-Regular',
      ),
      decoration: InputDecoration(
        hintText: isPassword ? 'Enter your password' : 'Enter your email',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : Icon(Icons.email, color: Colors.white70),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style:
          const TextStyle(color: Colors.white, fontFamily: 'Poppins-Regular'),
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Poppins-Light',
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
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

  Widget _buildRememberForgot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberUser,
              onChanged: (value) {
                setState(() {
                  rememberUser = value!;
                });
              },
            ),
            _buildGreyText("Remember me"),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forget Password?",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins-Regular',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          _showErrorDialog("Email and Password cannot be empty.");
        } else {
          // Mengambil email dan password dari controller
          String email = emailController.text;
          String password = passwordController.text;

          // Menjalankan login request ke backend
          try {
            // Mengirim email dan password untuk login
            User user = await UserClient.login(email, password);

            if (user.token != null && user.token!.isNotEmpty) {
              showToast("Login Success !!!");
              // Jika login berhasil dan token diterima, lanjutkan ke home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const homePage()),
              );
            } else {
              // Jika token kosong, tampilkan error
              errorToast("Email or Password is Incorrect !!!");
            }
          } catch (e) {
            // Tangani error jika ada masalah saat melakukan request
            errorToast("Email or Password is Incorrect !!!");
          }
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
        "LOGIN",
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins-SemiBold',
          fontSize: 16,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("Login with"),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset("images/google.png", height: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset("images/facebook.png", height: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset("images/twitter.png", height: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Register",
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
}
