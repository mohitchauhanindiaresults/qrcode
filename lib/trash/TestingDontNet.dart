import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scanner_app/FaceDetactionScreen.dart';
import 'package:scanner_app/testing4.dart';
import 'package:scanner_app/trash/Base64ImageScreen.dart';

class TestingDontNet extends StatefulWidget {
  @override
  _TestingDontNetState createState() => _TestingDontNetState();
}

class _TestingDontNetState extends State<TestingDontNet> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? _lastScannedCode;
  bool _isScanning = true; // Add this flag


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showDialog(BuildContext context, Map<String, dynamic> jsonMap, String htmlData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ACTION"),
          content: Text(
              "Would you like to view the form or proceed with face detection?"),
          actions: [
            TextButton(
              onPressed: () {
                print("object");
                Navigator.pop(context); // Close the dialog box
                // Navigate to the "View Form" screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Testing_four(
                        htmlData: generateAdmitCardHtml(htmlData, jsonMap)),
                  ),
                ).then((value) => _isScanning = true);
              },
              child: Text(
                "View Form",
                style: TextStyle(color: Colors.green),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context); // Close the dialog box
            //
            //
            //   },
            //   child: Text(
            //     "Face Detection",
            //     style: TextStyle(color: Colors.green),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if WebView can go back

        exit(0);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 350),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCamera(
                          qrCodeCallback: (code) {
                            print("object1232");
                            //   Fluttertoast.showToast(msg: code.toString());
                            printLongString(code.toString());
                            // print(code);
                            if (_isScanning == true) {
                              try {
                                _isScanning = false; // Disable scanning after first scan
                                print("track11");



                               Map<String, dynamic> jsonMap = jsonDecode(code.toString());
                                // JsonDataClass model = JsonDataClass.fromJson(jsonMap);

                                // print("track2");
                                 String? c1Value = jsonMap['ImageUrl'];
                                print("track0");
                                printLongString( c1Value!);
                                Fluttertoast.showToast(msg: "success");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Base64ImageScreen(
                                      base64String: c1Value!,
                                    ),
                                  ),
                                );

                                // print(c1Value); // Output will be: P
                                // // Utils.saveStringToPrefs(Constant.C1, jsonMap['examResult']?['C1']);
                                // // Utils.saveStringToPrefs(Constant.C2, jsonMap['examResult']?['C2']);
                                // // Utils.saveStringToPrefs(Constant.C3, jsonMap['examResult']?['C3']);
                                // // Utils.saveStringToPrefs(Constant.C4, jsonMap['examResult']?['C4']);
                                // // Utils.saveStringToPrefs(Constant.C5, jsonMap['examResult']?['C5']);
                                // // Utils.saveStringToPrefs(Constant.C6, jsonMap['examResult']?['C6']);
                                // // Utils.saveStringToPrefs(Constant.C7, jsonMap['examResult']?['C7']);
                                // // Utils.saveStringToPrefs(Constant.C8, jsonMap['examResult']?['C8']);
                                // // Utils.saveStringToPrefs(Constant.C9, jsonMap['examResult']?['C9']);
                                // Utils.saveStringToPrefs(Constant.C10, jsonMap['examResult']?['C10']);
                                // Utils.saveStringToPrefs(Constant.C12, jsonMap['examResult']?['C12']);



                                /// FOT THE APP OF SCANNER
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) =>Testing_four(htmlData: generateAdmitCardHtml(htmlData,jsonMap))),).then((value) => _isScanning = true);

                                /// FOR THE APP OF FACE DETECTION

                                //  print("track3");
                                //  String? c1Value = jsonMap['Base64ofStudentImage'];
                                //  print(c1Value);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) =>FaceDetactionScreen( jsonMap['Base64ofStudentImage'])),).then((value) => _isScanning = true);
                              } catch (e) {
                                print("Conversion to Uint8List failed: $e");
                                _isScanning = true;
                              }
                            }

                            //    Navigator.pop(context, code);
                          },
                        ),
                      ),
                    );
                  }, child: Text(" Scan a QR")),
              // ElevatedButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) =>FaceComparisonScreen()));
              //
              // },  child: Text(" Face recogonization testing")),
              // ElevatedButton(onPressed: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) =>FaceComparisonScreen()));
              //
              // },  child: Text(" Face recogonization tesarflow"))
            ],
          ),
        ),
      ),
    );
  }
  // String generateAdmitCardHtml(String htmlTemplate, Map<String, dynamic> dataMap) {
  //   // Loop through the dataMap and replace all placeholders in the HTML template
  //
  //
  //   dataMap.forEach((key, value) {
  //     // Replace placeholders like {{C1}}, {{C2}}, ... with the corresponding values in the dataMap
  //     print('{{$key}} kabooter');
  //     print(value.toString());
  //
  //     htmlTemplate = htmlTemplate.replaceAll('{{$key}}', value.toString());
  //   });
  //
  //   return htmlTemplate;
  // }

  String generateAdmitCardHtml(String htmlTemplate, Map<String, dynamic> dataMap) {
    printLongString("Befpre"+htmlTemplate);
    // Extract the nested 'cleanedModel' map if it exists in the dataMap
    if (dataMap.containsKey('cleanedModel') && dataMap['cleanedModel'] is Map<String, dynamic>) {
      Map<String, dynamic> cleanedModel = dataMap['cleanedModel'];

      // Loop through the cleanedModel map and replace placeholders in the HTML template
      cleanedModel.forEach((key, value) {
        htmlTemplate = htmlTemplate.replaceAll('{{$key}}', value.toString());
      });
    }
    printLongString("Befpre1"+htmlTemplate);

    // Replace other placeholders outside of 'cleanedModel' if needed
    dataMap.forEach((key, value) {
      if (key != 'cleanedModel') {
        // Special handling for the Base64ofStudentImage key to embed in an <img> tag
        if (key == 'Base64ofStudentImage') {
          htmlTemplate = htmlTemplate.replaceAll('{{Base64ofStudentImage}}', 'data:image/png;base64,$value');
        } else {
          htmlTemplate = htmlTemplate.replaceAll('{{$key}}', value.toString());
        }
      }
    });
    printLongString("Befpre2"+htmlTemplate);

    return htmlTemplate;
  }

  String enhanceImageQualityAndReturnBase64(String base64Str) {
    // Decode base64 to image bytes
    Uint8List bytes = base64Decode(base64Str);

    // Decode image from bytes
    img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage != null) {
      // Enhance image quality by resizing (double the size for better resolution)
      img.Image resizedImage =
      img.copyResize(decodedImage, width: decodedImage.width * 2);

      // Optionally apply further enhancements (e.g., sharpening, contrast adjustments, etc.)
      // img.Image enhancedImage = img.adjustColor(resizedImage, contrast: 1.2);

      // Encode the enhanced image back to PNG format
      Uint8List enhancedBytes = Uint8List.fromList(img.encodePng(resizedImage));

      // Convert back to base64
      return base64Encode(enhancedBytes);
    }

    // If decoding fails, return the original base64 string
    return base64Str;
  }

  static void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
