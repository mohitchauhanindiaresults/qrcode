import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
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

    
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div id="vresprint">
                    <table width="100%" border="0" cellspacing="0" style="border-collapse: collapse;" cellpadding="0">
                    <tr>
                        <td class="table" colspan="2" style="text-align: center">
                            <h1 class="logo-title" style="font-size: 20px;">Punjab State Teacher Eligibility Test
                                <br />
                                <span style="font-size: 15px">December-2024 
                                <br />
                                    ADMIT CARD (PROVISIONAL)
                                <br />
                                    EXAMINATION DATE - 01.12.2024 (Sunday)
                                </span>
                            </h1>


                           
                        Admit Card should be Printed in Colour only. Black & White Printout will not be accepted
                        </td>
                     
                        <td class="table" style="width: 200px; text-align: center; vertical-align: middle; font-weight: bold; font-size: 24px;">{{C2}}
                            <div style="text-align: center; vertical-align: middle; padding: 5px; padding-top: 10px; margin-top: 10px; font-weight: bold; font-size: 15px; border-top: solid 1px #000">
                                Student Copy
                            </div>
                        </td>
                    </tr>

                    <tr class="table" style="background-color: lightgray">
                        <td colspan="3" style="text-align: left; vertical-align: middle; padding: 5px; font-size: 15px;">Candidate's Details
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" style="border: solid 1px #000; padding: 0; border-top: none; border-bottom: none">
                            <table border="0" style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-left: none; border-top: none">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700;">Centre Code/Name</div>
                                        <div style="padding: 5px;">{{C3}}-{{C4}} </div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-top: none">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700">Application Form No</div>
                                        <div style="padding: 5px;">{{C5}}</div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-right: none; border-top: none">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700">Roll No.</div>
                                        <div style="padding: 5px;">{{C6}}</div>
                                    </td>
                                    <td rowspan="3" style="border: solid 1px #000; padding: 5px; border-right: none; border-top: none">
                                        <img src="{{Base64ofStudentImage}}" height="160px" width="120px" />

                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-left: none">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700">Name of Candidate</div>
                                        <div style="padding: 5px;">{{C7}}</div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000;">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700">Father's Name</div>
                                        <div style="padding: 5px;">{{C8}}</div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-right: none;">

                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700">Mother's Name</div>
                                        <div style="padding: 5px;">{{C9}}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-left: none">
                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700;">Category</div>
                                        <div style="padding: 5px; font-size: 13px !important">
                                            {{C10}}
                                        </div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-left: none">
                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700;">Differently Abled</div>
                                        <div style="padding: 5px;">
                                            {{C11}}
                                        </div>
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; font-size: 15px; font-weight: 400; border: solid 1px #000; border-right: none;">
                                     
                                        <div style="padding: 5px; border-bottom: solid 1px #000; font-weight: 700; border-left: none">
                                            Subject

                                        </div>
                                        <div style="padding: 5px;">{{C13}}</div>
                                      
                                        
                                    </td>
                                </tr>
                                <tr>

                                    <td colspan="4" style="text-align: left; vertical-align: middle; padding: 5px; font-size: 15px; font-weight: 700; border: solid 1px #000; border-left: none;">Exam Centre:- <span style="padding: 5px; font-weight: 400">{{C12}}</span>

                                    </td>

                                   
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3" style="border: solid 1px #000; padding: 0; border-top: none; border-bottom: none">
                            <table border="0" style="width: 100%; border-collapse: collapse;">
                                <tr>
                                    <td style="background: lightgray; text-align: center; vertical-align: middle; padding: 5px; font-size: 15px; border: solid 1px #000; border-right: none; border-top: none; border-left: none;">Date of Examination
                                    </td>
                                    <td style="background: lightgray; text-align: center; vertical-align: middle; padding: 5px; font-size: 15px; border: solid 1px #000; border-right: none; border-top: none;">Reporting Time
                                    </td>
                                    <td style="background: lightgray; text-align: center; vertical-align: middle; padding: 5px; font-size: 13px; border: solid 1px #000; border-right: none; border-top: none;">Time of Examination
                                    </td>
                                   
                                </tr>
                                <tr>
                                    <td style="text-align: center; vertical-align: middle; padding: 5px; font-size: 15px; font-weight: 400; border: solid 1px #000; border-right: none; border-left: none">{{C14}}</td>
                                    <td style="text-align: center; vertical-align: middle; padding: 5px; font-size: 15px; font-weight: 400; border: solid 1px #000; border-right: none">{{C15}}
                                    </td>
                                    <td style="text-align: center; vertical-align: middle; padding: 5px; font-size: 13px; font-weight: 400; border: solid 1px #000; border-right: none">{{C16}}
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center; vertical-align: bottom; border: solid 1px #000; padding: 5px; border-top: none; border-right: none; border-left: none">Roll No. Authentication Box </td>
                                    <td style="text-align: center; vertical-align: bottom; border: solid 1px #000; padding: 5px; border-top: none; border-right: none">Signature of Invigilator </td>
                                    <td style="text-align: center; border: solid 1px #000; padding: 5px; border-top: none; border-right: none">
                                        <img src="images/sanjeevsharma.jpg" style="width: 100px" />
                                        <br />
                                        ( Secretary )
                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="3" style="border: solid 1px #000; padding: 5px; border-top: none;">
                            <h5 style="text-align: center; font-weight: 700; text-decoration: underline; font-size: 18px; margin: 0">INSTRUCTIONS FOR CANDIDATES(Please Read Carefully)
                            </h5>
                            <ol style="padding-left: 18px">
                                <li>This Admit Card is subject to condition that if ineligibility is detected at any stage , the candidature will be cancelled.</li>
                                <li>Candidate shall be provided pen to attempt exam.</li>
                                <li>All candidates will be under surveillance, inside the Examination Center premises hence advised not to indulge in any unlawful activity which may invite disqualification and legal action.
                                </li>
                                <li>Entry to Examination Hall is subject to production of Admit Card and Photo ID proof to prove your identity.
                                </li>
                                <li>Pen, Cell Phones, Watches, Pagers, Calculators or any Electronic Devices are strictly prohibited. Violation may lead to expulsion from
the examination including cancellation of Candidature.
                                </li>
                                <li>Do not carry any articles, except Admit Card & Photo ID in the Examination Hall.
                                </li>
                                <li>Do not attempt to give or obtain assistance of any kind in the Examination Hall.
                                </li>
                                <li>Any attempt to remove pages from Question Booklet is strictly prohibited and shall lead to cancellation of Candidature.
                                </li>
                                <li>Copying or noting down question is strictly prohibited.</li>
                                <li>Improper conduct will entail expulsion from the examination.
                                </li>
                                <li>PSTET-24 reserves all rights to verify identity and genuineness of each candidate by taking Facial recognition / photograph of the candidate or by
any other means.
                                </li>
                                <li>Preserve this Admit Card for record.

                                </li>
                                <li>Failure to comply with these instructions will entail expulsion/cancellation of candidature or appropriate legal action.

                                </li>
                                <li>No entry is allowed in Examination Hall after half an hour on start of exam.

                                </li>


                                <li>Candidate cannot leave Examination Hall without permission of Invigilator.


                                </li>

                                <li>Do not leave the hall without handing over OMR Answer Sheet to the invigilator

                                </li>

                                <li>Candidate must sign the attendance Sheet. Missing signature on attendance sheet shall be considered absent of the candidate.


                                </li>

                                <li>In case of any ambiguity in any question, the query can be submitted to expert commitee through online grievance on website www.pstet.pseb.ac.in.
The decision of the expert committee shall be final. No query shall be entertained their after.


                                </li>

                                <li>The candidate is advised to visit website www.pstet.pseb.ac.in/www.pseb.ac.in, regularly. No separate communication shall be made to any candidate.

                                </li>

                                <li>Candidate requiring scriber (writer) shall submit separate admit card/proforma for scriber to the centre superintendent.


                                </li>

                                <li>Paste recent passport size colored photograph attested by Gazetted Officer on office copy.

                                </li>

                                <li>The Candidate having 40% or more disability should be allowed 20 minutes extra time per hour as compensatory time.
                                </li>

                            </ol>
                        </td>
                    </tr>
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

  void _showDialog(
      BuildContext context, Map<String, dynamic> jsonMap, String htmlData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ACTION"),
          content: Text("Would you like to view the form ?"),
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
                                _isScanning =
                                    false; // Disable scanning after first scan
                                print("track0");

                                String base64String =
                                    compressedNumberToBase64(code.toString());
                                print("track000");

                                printLongString(base64String);

                                String decompressedData =
                                    decompressGzipFromString(base64String);
                                print("track1");
                                printLongString(decompressedData);

                                Map<String, dynamic> jsonMap =
                                    jsonDecode(decompressedData);
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
                                printLongString(generateAdmitCardHtml(htmlData, jsonMap));

                                _showDialog(context, jsonMap, htmlData);

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
                  },
                  child: Text(" Scan a QR")),
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

  String generateAdmitCardHtml(
      String htmlTemplate, Map<String, dynamic> dataMap) {
    printLongString("Befpre" + htmlTemplate);
    // Extract the nested 'cleanedModel' map if it exists in the dataMap
    if (dataMap.containsKey('cleanedModel') &&
        dataMap['cleanedModel'] is Map<String, dynamic>) {
      Map<String, dynamic> cleanedModel = dataMap['cleanedModel'];

      // Loop through the cleanedModel map and replace placeholders in the HTML template
      cleanedModel.forEach((key, value) {
        htmlTemplate = htmlTemplate.replaceAll('{{$key}}', value.toString());
      });
    }
    printLongString("Befpre1" + htmlTemplate);

    // Replace other placeholders outside of 'cleanedModel' if needed
    dataMap.forEach((key, value) {
      if (key != 'cleanedModel') {
        // Special handling for the Base64ofStudentImage key to embed in an <img> tag
        if (key == 'Base64ofStudentImage') {
          htmlTemplate = htmlTemplate.replaceAll(
              '{{Base64ofStudentImage}}', 'data:image/png;base64,$value');
        } else {
          htmlTemplate = htmlTemplate.replaceAll('{{$key}}', value.toString());
        }
      }
    });
    printLongString("Befpre2" + htmlTemplate);

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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
