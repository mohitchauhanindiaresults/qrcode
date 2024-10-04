import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, rootBundle;
import 'package:scanner_app/Constant.dart';
import 'package:scanner_app/JsonDataClass.dart';
import 'package:scanner_app/Utils.dart';
import 'package:scanner_app/certificate/CertificateScreen.dart';
import 'package:scanner_app/testing4.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? _lastScannedCode;
  bool _isScanning = true; // Add this flag
  String htmlData = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <title>Admit Card</title>
    <style>
        .themebtn {
            background: #1d6b9c;
            border: 1px solid #1d6b9c;
            color: #fff !important;
            padding: 4px 10px;
            cursor: pointer;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 2;
            margin-top: 10px;
        }
        @media print {
            .themebtn {
                display: none;
            }
        }
        td {
            padding: 2px !important;
        }
        table {
            font-size: 12px;
        }
        .ollisting {
            padding-left: 20px;
        }
        .ollisting li {
            margin-bottom: 1px;
            text-align: left;
            font-size: 10px;
        }
    </style>
</head>
<body>
    <center style="width: 100%; margin-top: 15px;">
        <a href="javascript:;" onclick="print()" class="themebtn" style="padding: 6px !important;">Print</a>
        <a href="home" class="themebtn" style="padding: 6px !important;">Back To Home</a>
    </center>
    
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div id="vresprint">
                    <table class="table">
                        <tr>
                            <td colspan="3" align="center" style="border: none;">
                                <small>*****CANDIDATE MUST CARRY THE PRINTED COPY OF THIS ADMIT CARD ON THE DAY OF EXAMINATION*****</small>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" style="border: none; background: #1d6b9c; border: 1px solid #000;">
                                <img src="assets/images/ssbHeader.jpg" style="height: 70px;">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" style="border: 1px solid #000; padding: 5px 0 !important;">
                                JAMMU & KASHMIR SERVICES SELECTION BOARD RECRUITMENT EXAMINATION.
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" style="border: 1px solid #000; padding: 5px 0 !important;">
                                <strong style="font-size: 16px;">{{C1}}</strong></br>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                ROLL NUMBER
                            </td>
                            <td style="border: 1px solid #000; width: 50%;padding: 0 !important;vertical-align: middle;line-height: 0;">
                                <table style="width: 100%;">
                                    <tr>
                                        <td style="width: 100%; ">
                                            <strong style="font-size: 22px;">{{C2}}</strong>    
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="border: 1px solid #000; width: 20%;" rowspan="7" align="center">
                                <img src="{{Base64ofStudentImage}}" style="width: 120px; margin: 5px;">
                            </td>
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                ADVERTISEMENT NO
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C4}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                ITEM NO (S)
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C5}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                APPLICATION NO (S)
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C6}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                CANDIDATE'S NAME
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C7}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                FATHER'S NAME 
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C8}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                MOTHER'S NAME
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C9}}
                            </td> 
                        </tr>
                        
                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                DATE OF BIRTH
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C10}}
                            </td> 
                            <td style="border: 1px solid #000; width: 20%;" rowspan="6" align="center">
                                <small><b>Candidate to paste<br>his/her recent passport<br>size colour photograph<br>with name and date<br><br>(not older than 06 months from the date of examination)</b><br><br>(To be pasted before<br>reaching the Centre)</small>
                            </td>
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                PWD (PERSONS WITH DISABILITY)
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C11}}
                            </td>
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                CORRESPONDENCE ADDRESS 
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C12}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                POST NAME 
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C13}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                DATE OF EXAMINATION 
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C14}}
                            </td> 
                        </tr>

                        <tr>
                            <td style="border: 1px solid #000; width: 30%">
                                EXAMINATION CITY NAME
                            </td>
                            <td style="border: 1px solid #000; width: 50%;">
                                {{C15}}
                            </td> 
                        </tr>

                   
                        
                        <!-- Additional rows can be added here as needed, following the pattern {{C20}}, {{C21}}, etc. -->
                        
                    </table>
                </div>
            </div>
        </div>
    </div>

    <center style="width: 100%; margin-top: 15px;">
        <a href="javascript:;" onclick="print()" class="themebtn" style="padding: 6px !important;">Print</a>
        <a href="home" class="themebtn" style="padding: 6px !important;">Back To Home</a>
    </center>
</body>
</html>
""";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 350),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrCamera(

                    onError: (context, error) => Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    qrCodeCallback: (code) {
                      print("object1232");
                   //   Fluttertoast.showToast(msg: code.toString());
                      printLongString( code.toString());
                     // print(code);
                      try {
                        //    _isScanning = false; // Disable scanning after first scan
                        print("track0");

                        String base64String = compressedNumberToBase64(code.toString());
                        printLongString(base64String);

                        String decompressedData = decompressGzipFromString(base64String);
                        print("track1");
                        printLongString(decompressedData);

                        Map<String, dynamic> jsonMap = jsonDecode(decompressedData);
                        // JsonDataClass model = JsonDataClass.fromJson(jsonMap);

                        // print("track2");
                        // String? c1Value = jsonMap['examResult']?['C12'];
                        //
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


                        print("track2");
                        printLongString(generateAdmitCardHtml(htmlData,jsonMap));

                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>Testing_four(htmlData: generateAdmitCardHtml(htmlData,jsonMap))),
                        ).then((value) => _isScanning = true);

                      } catch (e) {
                        print("Conversion to Uint8List failed: $e");
                        _isScanning = true;
                      }
                 //    Navigator.pop(context, code);
                    },
                  ),
                ),
              );

            }, child: Text(" Scan a QR"))
          ],
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

    static void printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }



  String compressedNumberToBase64(String compressedNumber1) {
    BigInt compressedNumber = BigInt.parse(compressedNumber1);
    Uint8List byteArray = _bigIntToByteArray(compressedNumber);

    // Remove any trailing 0 from byteArray, if present
    if (byteArray.isNotEmpty && byteArray.last == 0) {
      byteArray = byteArray.sublist(0, byteArray.length - 1);
    }

    return base64Encode(byteArray);
  }

  Uint8List _bigIntToByteArray(BigInt bigInt) {
    // Ensure the BigInt is represented correctly in a hexadecimal string
    String hexString = bigInt.toRadixString(16);

    // If the length of hexString is odd, pad with a leading zero to make it even
    if (hexString.length % 2 != 0) {
      hexString = '0' + hexString;
    }

    List<int> byteList = [];
    for (int i = 0; i < hexString.length; i += 2) {
      byteList.add(int.parse(hexString.substring(i, i + 2), radix: 16));
    }

    return Uint8List.fromList(byteList.reversed.toList()); // Reverse for little-endian
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
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
