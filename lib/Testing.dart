import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, rootBundle;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_app/JsonDataClass.dart';
import 'package:scanner_app/certificate/CertificateScreen.dart';

class MyHomePageeeeeeeeeeeee extends StatefulWidget {
  const MyHomePageeeeeeeeeeeee({super.key});

  @override
  State<MyHomePageeeeeeeeeeeee> createState() => _MyHomePageeeeeeeeeeeeeState();
}

class _MyHomePageeeeeeeeeeeeeState extends State<MyHomePageeeeeeeeeeeee> {
  String? _lastScannedCode;
  bool _isScanning = true; // Add this flag

  @override
  void initState() {
    super.initState();
    // Enable full-screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (!_isScanning) return; // Prevent scanning after first detection

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final code = barcode.rawValue ?? "No Data found in QR";
                try {
                  _isScanning = false; // Disable scanning after first scan

                  // Convert the large Base64 string to Uint8List
                  String base64String = compressedNumberToBase64(code);

                  printLongString(base64String);

                  String decompressedData = decompressGzipFromString(base64String);
                  print("track1");
                  printLongString(decompressedData);
                  //
                   Map<String, dynamic> jsonMap = jsonDecode(decompressedData);
                   JsonDataClass model = JsonDataClass.fromJson(jsonMap);
                  //
                  // // Access data
                  // print("track2");
                  // print(model.examResult?.backgroundImageUrl);
                  // print(model.examResult
                  //     ?.values['C1']); // Accessing dynamically added "C" properties
                  // print(model.base64ofStudentImage);
                  // print("track3");

                  print("track2");
                  String? c1Value = jsonMap['examResult']?['C10'];
                  print(c1Value); // Output will be: P

                  // Navigate to CertificateWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CertificateWidget()),
                  ).then((value) => _isScanning = true); // Enable scanning when returning

                } catch (e) {
                  print("Conversion to Uint8List failed: $e");
                  _isScanning = true; // Re-enable scanning if an error occurs
                }
              }
            },
          ),
          Center(
            child: Text(
              'Scan a QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  String compressedNumberToBase64(String compressedNumber1) {
    BigInt compressedNumber = BigInt.parse(compressedNumber1);
    Uint8List byteArray = _bigIntToByteArray(compressedNumber);

    if (byteArray.isNotEmpty && byteArray.last == 0) {
      byteArray = byteArray.sublist(0, byteArray.length - 1);
    }

    return base64Encode(byteArray);
  }

  Uint8List _bigIntToByteArray(BigInt bigInt) {
    var bytes = bigInt
        .toUnsigned(8 * ((bigInt.bitLength + 7) >> 3))
        .toRadixString(16)
        .padLeft((bigInt.bitLength + 7) >> 3 * 2, '0');

    List<int> byteList = [];
    for (int i = 0; i < bytes.length; i += 2) {
      byteList.add(int.parse(bytes.substring(i, i + 2), radix: 16));
    }

    return Uint8List.fromList(
        byteList.reversed.toList()); // Reverse for little-endian
  }

  String decompressGzipFromString(String compressedData) {
    try {
      Uint8List compressedBytes = base64.decode(compressedData);

      List<int> decompressedBytes = GZipDecoder().decodeBytes(compressedBytes);

      return utf8.decode(decompressedBytes);
    } catch (e) {
      print('Decompression failed: $e');
      return '';
    }
  }
}
