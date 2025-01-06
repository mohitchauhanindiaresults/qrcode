import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'Utils.dart';

class FaceComparisonScreen extends StatefulWidget {
  @override
  _FaceComparisonScreenState createState() => _FaceComparisonScreenState();
}

class _FaceComparisonScreenState extends State<FaceComparisonScreen> {
  File? image1;
  File? image2;
  final picker = ImagePicker();
  String resultMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Comparison")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (image1 != null) Image.file(image1!, width: 100, height: 100),
                if (image2 != null) Image.file(image2!, width: 100, height: 100),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: captureImages,
              child: Text("Capture Images"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkFaceSimilarity,
              child: Text("Check Similarity"),
            ),
            SizedBox(height: 20),
            Text(resultMessage),
          ],
        ),
      ),
    );
  }

  Future<void> captureImages() async {
    final capturedFile1 = await picker.pickImage(source: ImageSource.camera);
    final capturedFile2 = await picker.pickImage(source: ImageSource.camera);

    if (capturedFile1 != null && capturedFile2 != null) {
      setState(() {
        image1 = File(capturedFile1.path);
        image2 = File(capturedFile2.path);
      });
    }
  }

  Future<void> checkFaceSimilarity() async {
    Utils.progressbar(context, 0xFF000000);
    if (image1 == null || image2 == null) {
      setState(() {
        resultMessage = "Please capture two images.";
      });
      Navigator.pop(context);

      return;
    }

    final faces1 = await detectFaces(image1!);
    final faces2 = await detectFaces(image2!);

    if (faces1.isEmpty || faces2.isEmpty) {
      setState(() {
        resultMessage = "No faces detected in one or both images.";
      });
      Navigator.pop(context);
      return;
    }

    final croppedImage1 = await cropAndResizeFace(image1!, faces1.first);
    final croppedImage2 = await cropAndResizeFace(image2!, faces2.first);

    final croppedFaces1 = await detectFaces(croppedImage1);
    final croppedFaces2 = await detectFaces(croppedImage2);

    double minDistance = double.infinity;
    for (var face1 in croppedFaces1) {
      for (var face2 in croppedFaces2) {
        double? distance = calculateNormalizedSimilarity(face1, face2);
        if (distance != null && distance < minDistance) {
          minDistance = distance;
        }
      }
    }


    print("object");
    print(minDistance);
    setState(() {
      resultMessage = (minDistance < 0.06) ? "Faces are similar!" : "Faces are not similar.";
    });
    Navigator.pop(context);
  }

  double? calculateNormalizedSimilarity(Face face1, Face face2) {
    final landmarks1 = face1.landmarks;
    final landmarks2 = face2.landmarks;

    Map<FaceLandmarkType, double> weightedLandmarks = {
      FaceLandmarkType.noseBase: 1.5,
      FaceLandmarkType.leftEye: 1.2,
      FaceLandmarkType.rightEye: 1.2,
      FaceLandmarkType.bottomMouth: 1.3,
      FaceLandmarkType.leftMouth: 1.0,
      FaceLandmarkType.rightMouth: 1.0,
    };

    double totalWeightedDistance = 0.0;
    double weightSum = 0.0;

    final faceWidth1 = face1.boundingBox.width;
    final faceHeight1 = face1.boundingBox.height;
    final faceWidth2 = face2.boundingBox.width;
    final faceHeight2 = face2.boundingBox.height;

    for (var entry in weightedLandmarks.entries) {
      var landmark1 = landmarks1[entry.key];
      var landmark2 = landmarks2[entry.key];

      if (landmark1 != null && landmark2 != null) {
        double distance = calculateDistance(
          Point(landmark1.position.x / faceWidth1, landmark1.position.y / faceHeight1),
          Point(landmark2.position.x / faceWidth2, landmark2.position.y / faceHeight2),
        );
        totalWeightedDistance += distance * entry.value;
        weightSum += entry.value;
      }
    }

    return weightSum > 0 ? totalWeightedDistance / weightSum : null;
  }

  Future<File> cropAndResizeFace(File imageFile, Face face) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) return imageFile;

    final boundingBox = face.boundingBox;
    final margin = 20; // Extra margin around the face
    final croppedImage = img.copyCrop(
      originalImage,
      x: max(0, (boundingBox.left - margin).toInt()),
      y: max(0, (boundingBox.top - margin).toInt()),
      width: min(boundingBox.width + margin * 2, originalImage.width - boundingBox.left).toInt(),
      height: min(boundingBox.height + margin * 2, originalImage.height - boundingBox.top).toInt(),
    );
    final standardizedImage = img.copyResize(croppedImage, width: 128, height: 128);

    final outputFile = File('${imageFile.path}_cropped.jpg')
      ..writeAsBytesSync(img.encodeJpg(standardizedImage));

    return outputFile;
  }

  double calculateDistance(Point<double> p1, Point<double> p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  Future<List<Face>> detectFaces(File image) async {
    final inputImage = InputImage.fromFile(image);
    final faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);
    faceDetector.close();
    return faces;
  }
}
