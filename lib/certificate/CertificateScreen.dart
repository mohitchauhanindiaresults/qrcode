import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initate();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: CertificateWidget(),
      ),
    );
  }

  void initate() {


  }
}


class CertificateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // You can adjust these ratios based on your design needs
    double imageWidthRatio = 0.9; // 90% of the screen width for the image
    double imageHeightRatio = 0.7; // 70% of the screen height for the image

    return Center(
      child: Stack(
        children: [
          // Background image with responsive scaling
          Center(
            child: Container(
              width: screenWidth * imageWidthRatio,
              height: screenHeight * imageHeightRatio,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/osstet.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Positioned text with relative positioning
          Positioned(
            left: screenWidth * 0.798, // Adjust the left positioning based on screen width
            top: screenHeight * 0.308, // Adjust the top positioning based on screen height
            child: Transform.rotate(
              angle: 1.5709, // 90 degrees rotation (in radians)
              child: Text(
                'Rotated Text',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.02, // Scale font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
