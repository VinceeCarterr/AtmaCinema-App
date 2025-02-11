import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'ATMA Cinema',
                  textStyle: TextStyle(
                    fontFamily: 'Poppins-SemiBold',
                    fontSize: 36.0,
                    color: Colors.white,
                    letterSpacing: 0,
                  ),
                ),
              ],
              totalRepeatCount: 1,
              pause: Duration(milliseconds: 500),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ],
        ),
      ),
    );
  }
}
