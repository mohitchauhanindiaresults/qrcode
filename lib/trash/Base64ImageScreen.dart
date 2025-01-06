import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageScreen extends StatelessWidget {
  final String base64String;

  Base64ImageScreen({required this.base64String});

  @override
  Widget build(BuildContext context) {
    // Decode the base64 string to get the image bytes
    Uint8List bytes = base64Decode(base64String.split(',').last);

    return Scaffold(
      appBar: AppBar(
        title: Text("Display Base64 Image"),
      ),
      body: Center(
        child: Image.memory(bytes),
      ),
    );
  }
}
