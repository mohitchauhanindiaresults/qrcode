import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, rootBundle;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_app/Constant.dart';
import 'package:scanner_app/JsonDataClass.dart';
import 'package:scanner_app/Utils.dart';
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
          // Wrap MobileScanner with a Container and set a background color for visibility
          Container(
            color: Colors.blue, // Temporary color to check visibility
            height: 300.0, // Adjust this height based on your requirements
            width: double.infinity,
            child: MobileScanner(

              onDetect: (capture) {
                if (!_isScanning) return;

                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final code = barcode.rawValue ?? "No Data found in QR";
                  try {
                    //    _isScanning = false; // Disable scanning after first scan

                    String base64String = compressedNumberToBase64(code);
                    printLongString(base64String);

                    String decompressedData = decompressGzipFromString(base64String);
                    print("track1");
                    printLongString(decompressedData);

                    Map<String, dynamic> jsonMap = jsonDecode(decompressedData);
                   // JsonDataClass model = JsonDataClass.fromJson(jsonMap);

                    print("track2");
                    String? c1Value = jsonMap['examResult']?['C12'];
                    print(c1Value); // Output will be: P
                    // Utils.saveStringToPrefs(Constant.C1, jsonMap['examResult']?['C1']);
                    // Utils.saveStringToPrefs(Constant.C2, jsonMap['examResult']?['C2']);
                    // Utils.saveStringToPrefs(Constant.C3, jsonMap['examResult']?['C3']);
                    // Utils.saveStringToPrefs(Constant.C4, jsonMap['examResult']?['C4']);
                    // Utils.saveStringToPrefs(Constant.C5, jsonMap['examResult']?['C5']);
                    // Utils.saveStringToPrefs(Constant.C6, jsonMap['examResult']?['C6']);
                    // Utils.saveStringToPrefs(Constant.C7, jsonMap['examResult']?['C7']);
                    // Utils.saveStringToPrefs(Constant.C8, jsonMap['examResult']?['C8']);
                    // Utils.saveStringToPrefs(Constant.C9, jsonMap['examResult']?['C9']);
                    Utils.saveStringToPrefs(Constant.C10, jsonMap['examResult']?['C10']);
                    Utils.saveStringToPrefs(Constant.C12, jsonMap['examResult']?['C12']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CertificateWidget()),
                    ).then((value) => _isScanning = true);

                  } catch (e) {
                    print("Conversion to Uint8List failed: $e");
                    _isScanning = true;
                  }
                }
              },

            ),
          ),
          // Ensure the text widget doesn't block the scanner view
          Positioned(
            bottom: 50.0, // Move text lower so it's not on top of the scanner
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Scan a QR Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
