import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scanner_app/Testing.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer for 6 seconds, then navigate to the next screen
    _timer = Timer(Duration(milliseconds: 2800), _navigateToNextScreen);
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  // Function to navigate to the next screen
  Future<void> _navigateToNextScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyHomePageeeeeeeeeeeee(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
          child: ElevatedButton(
        onPressed: () {
          _navigateToNextScreen();
        },
        child: Text("ddddddd"),
      )),
    );
  }
}
