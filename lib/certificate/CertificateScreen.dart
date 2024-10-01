import 'package:flutter/material.dart';
import 'package:scanner_app/Constant.dart';
import 'package:scanner_app/Utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: CertificateWidget(),
      ),
    );
  }


}


class CertificateWidget extends StatefulWidget {
  @override
  State<CertificateWidget> createState() => _CertificateWidgetState();
}

class _CertificateWidgetState extends State<CertificateWidget> {

  String C1="";
  String C2="";
  String C3="";
  String C4="";
  String C5="";
  String C6="";
  String C7="";
  String C8="";
  String C9="";
  String C10="";
  String C12="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initate();
  }
  void initate() async{
    // C1 = (await Utils.getStringFromPrefs(Constant.C1))!;
    // C2 = (await Utils.getStringFromPrefs(Constant.C2))!;
    // C3 = (await Utils.getStringFromPrefs(Constant.C3))!;
    // C4 = (await Utils.getStringFromPrefs(Constant.C4))!;
    // C5 = (await Utils.getStringFromPrefs(Constant.C5))!;
    // C6 = (await Utils.getStringFromPrefs(Constant.C6))!;
    // C7 = (await Utils.getStringFromPrefs(Constant.C7))!;
    // C8 = (await Utils.getStringFromPrefs(Constant.C8))!;
    // C9 = (await Utils.getStringFromPrefs(Constant.C9))!;
    C10 = (await Utils.getStringFromPrefs(Constant.C10))!;
    C12 = (await Utils.getStringFromPrefs(Constant.C12))!;
    setState(() {

    });

  }


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
            left: screenWidth * 0.490, // Adjust the left positioning based on screen width
            top: screenHeight * 0.450, // Adjust the top positioning based on screen height
            child: Transform.rotate(
              angle: 1.5709, // 90 degrees rotation (in radians)
              child: Text(
                C10,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.02, // Scale font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.440, // Adjust the left positioning based on screen width
            top: screenHeight * 0.450, // Adjust the top positioning based on screen height
            child: Transform.rotate(
              angle: 1.5709, // 90 degrees rotation (in radians)
              child: Text(
                C12,
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
