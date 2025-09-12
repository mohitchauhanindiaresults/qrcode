import 'dart:async';
import 'dart:convert';  // for base64 decoding/encoding
import 'dart:io';
import 'dart:typed_data';  // for Uint8List
import 'package:image/image.dart' as img;  // image packageimport 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner_app/Utils.dart';

class FaceDetactionScreen extends StatefulWidget {
  final String qrBase64;

  FaceDetactionScreen(this.qrBase64);

  @override
  _FaceDetactionScreenState createState() => _FaceDetactionScreenState();
}

class _FaceDetactionScreenState extends State<FaceDetactionScreen> {
  String? capturedBase64Image;
  bool _isImageTaken = false; // Flag to track if the picture is taken
  String erromesg='';

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imgFile = File(image.path);
      List<int> imageBytes = await imgFile.readAsBytes();
      setState(() {
        capturedBase64Image = base64Encode(imageBytes);
        _isImageTaken = true; // Set flag to true after taking a picture
      });
    }
  }

  void _compareImages() {
    // Add your image comparison logic here
    print("Comparing images...");
    printLongString(widget.qrBase64);
    print("image12");
    printLongString(capturedBase64Image!);
    makeApiRequest(context, enhanceImageQualityAndReturnBase64(widget.qrBase64), capturedBase64Image!);
    // This is just a placeholder function.
  }


  Future<void> makeApiRequest(BuildContext context, String base64, String base642) async {
    // Show progress dialog
    Utils.progressbar(context, 0xFF000000); // Adjust according to your Utils method

    // Define the URL of your API
    String apiUrl = "https://faceapi.mxface.ai/api/v3/face/verify";

    // Create a JSON object with your POST data
    Map<String, String> postData = {
      "encoded_image1": base64,  // Replace with actual Base64 image string
      "encoded_image2": base642, // Replace with actual Base64 image string
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Subscriptionkey": "KpKhpshHhgeL8lIcKB-i6yHrc8vxo3025", // API Key
        },
        body: jsonEncode(postData),
      );

      // Dismiss the progress dialog
      Navigator.pop(context);

      // Parse the response JSON once
      final responseData = jsonDecode(response.body);
      print("trace4");
      print(responseData);

      // Error message assignment
      erromesg = responseData['errorMessage'] ?? 'Unknown error';

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Extract the matchResult value
        print("trace5");

        if (responseData['matchedFaces'] != null && responseData['matchedFaces'].isNotEmpty) {
          int matchResult = responseData['matchedFaces'][0]['matchResult'];

          if (matchResult == 1) {
            showMatchResultDialog(context, "Face Matched");
          //  Fluttertoast.showToast(msg: "Face Matched");
          } else {
            showMatchResultDialog(context, "Face Not Matched");

       //     Fluttertoast.showToast(msg: "Face Not Matched");
          }
        } else {
          showMatchResultDialog(context, "No faces matched");

      //    Fluttertoast.showToast(msg: "No faces matched");
        }
      } else {
        // Handle server errors and display error message from response
        String errorMessage = responseData['error'] ?? 'Error: ${response.statusCode}';
        // Fluttertoast.showToast(msg: errorMessage);
      }
    } catch (e) {
      // Handle general exceptions and show error message
      // Fluttertoast.showToast(msg: erromesg);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Detection')),
      body: SingleChildScrollView(
        child: Center( // Center the entire column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Centered display of Base64 image
              Container(
                width: 200, // Fixed width for the image
                height: 200, // Fixed height for the image
                alignment: Alignment.center,
                child: widget.qrBase64.isNotEmpty
                    ? Image.memory(base64Decode(widget.qrBase64), fit: BoxFit.cover)
                    : Container(color: Colors.grey), // Placeholder if no image
              ),
              SizedBox(height: 20),
              Text('SCANNED IMAGE',style: TextStyle(color: Colors.green),),
              // Uncomment if you want to display Base64 string
              // Text(widget.qrBase64),

              SizedBox(height: 40), // Spacer for visual separation

              // Centered section for taking a picture and showing Base64
              if (!_isImageTaken) // Show button only if image is not taken
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Take Picture'),
                ),
              SizedBox(height: 20),
              if (capturedBase64Image != null)
                Container(
                  width: 200, // Fixed width for the captured image
                  height: 200, // Fixed height for the captured image
                  alignment: Alignment.center,
                  child: Image.memory(
                    base64Decode(capturedBase64Image!),
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              if (_isImageTaken) // Show this message only after taking a picture
                Column(
                  children: [
                    Text('CLICKED IMAGE',style: TextStyle(color: Colors.red),),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _compareImages, // Functionality to compare images
                      child: Text('Compare Images',style: TextStyle(color: Colors.black),
                    ),)
                  ],
                ),
              SizedBox(height: 30),
             // Text('Captured Base64 Image:'),
              // Uncomment to display captured Base64 string
              // Text(capturedBase64Image ?? ''),
            ],
          ),
        ),
      ),
    );
  }
  static void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  Future<void> showMatchResultDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Match Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String enhanceImageQualityAndReturnBase64(String base64Str) {
    // Decode base64 to image bytes
    Uint8List bytes = base64Decode(base64Str);

    // Decode image from bytes
    img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage != null) {
      // Enhance image quality by resizing (double the size for better resolution)
      img.Image resizedImage = img.copyResize(decodedImage, width: decodedImage.width * 2);

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
}
