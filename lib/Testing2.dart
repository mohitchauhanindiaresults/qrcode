// import 'package:flutter/material.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
//
// void main() {
//   final qrCode = QrCode(
//     8,
//     QrErrorCorrectLevel.H,
//   )..addData('lorem ipsum dolor sit amet');
//
//   final qrImage = QrImage(qrCode);
//
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: PrettyQrView(
//             qrImage: qrImage,
//             decoration: const PrettyQrDecoration(
//               image: PrettyQrDecorationImage(
//                 image: AssetImage('assets/gif/scanner.jpeg'),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }



//
//
// String generateCertificateHtml(JsonDataClass model) {
//   return '''
// <!DOCTYPE html>
// <html xmlns='http://www.w3.org/1999/xhtml'>
// <head>
//     <title>Certificate</title>
//     <style>
//         body {
//             background-image: url('assets/osstet.jpg');
//             background-repeat: no-repeat;
//             font-family: Arial, sans-serif;
//             font-size: 14px;
//             font-weight: bold;
//             position: relative;
//         }
//         .qr-code {
//             position: absolute;
//             bottom: 0;
//             left: 0;
//             width: 200px;
//             height: 200px;
//         }
//     </style>
// </head>
// <body>
//     <form id='form1' method='post'>
//         <table style='width:1000px; margin-top:50px;' cellpadding='8px' cellspacing='0'>
//             <tr>
//                 <td style='padding-left:150px; width:70%;'>${model.examResult?.values['C1']}</td>
//                 <td style='padding-left:155px'>${model.examResult?.values['C1']}</td>
//             </tr>
//             <tr>
//                 <td style='padding-left:195px;'>${model.examResult?.values['C3']}</td>
//                 <td style='padding-left:155px'>${model.examResult?.values['C4']}</td>
//             </tr>
//             <tr>
//                 <td style='padding-left:360px;padding-top:185px;'>${model.examResult?.values['C5']}</td>
//                 <td style='padding-left:140px' rowspan='2'>
//                     <img src='data:image/png;base64,${model.examResult?.values['C6']}' height='120px' width='100px' style='margin-top:90px;' />
//                 </td>
//             </tr>
//             <tr>
//                 <td style='padding-left:320px;'>${model.examResult?.values['C7']}</td>
//             </tr>
//             <tr>
//                 <td style='padding-left:180px;padding-top:35px;' colspan='2'>${model.examResult?.values['C8']}</td>
//             </tr>
//             <tr>
//                 <td colspan='2'>
//                     <table width='100%' cellspacing='0' cellpadding='0'>
//                         <tr>
//                             <td style='padding-left:150px; width:45%;'>${model.examResult?.values['C9']}</td>
//                             <td style='padding-left:10px;'>${model.examResult?.values['C10']} &nbsp; ${model.examResult?.values['C11']}</td>
//                         </tr>
//                     </table>
//                 </td>
//             </tr>
//             <tr>
//                 <td colspan='2'>
//                     <table width='100%' cellspacing='0' cellpadding='0'>
//                         <tr>
//                             <td style='padding-left:300px; width:60%;'></td>
//                         </tr>
//                     </table>
//                 </td>
//             </tr>
//             <tr>
//                 <td style='padding-left:290px;'>${model.examResult?.values['C12']}</td>
//                 <td>${model.examResult?.values['C13']}</td>
//             </tr>
//             <tr>
//                 <td colspan='2'>
//                     <table width='100%'>
//                         <tr>
//                             <td style='padding-left:100px; width:25%; padding-top:80px;'>${model.examResult?.values['C14']}</td>
//                             <td style='padding-top:80px; text-align:right;'>${model.examResult?.values['C15']}</td>
//                             <td style='padding-left:100px;padding-top:11px; text-align:center;' rowspan='2'>
//                                 <img src='${model.examResult?.values['signatureUrl']}' height='60px' width='200px' />
//                             </td>
//                         </tr>
//                     </table>
//                 </td>
//             </tr>
//         </table>
//         <div class='qr-code'>
//             <img src='data:image/png;base64,${model.examResult?.values['base64ImageQRCode']}' width='200' height='200' />
//         </div>
//     </form>
// </body>
// </html>
// ''';
// }}



//
//
//
//
//
//
// class DisplayResult extends StatefulWidget {
//   @override
//   _DisplayResultState createState() => _DisplayResultState();
// }
//
// class _DisplayResultState extends State<DisplayResult> {
//   String htmlData = '''
//    <html xmlns='http://www.w3.org/1999/xhtml'>
//    <head>
//        <title>Certificate</title>
//        <style>
//            body {
//                background-image: url('IMAGE_DATA'); /* Placeholder for base64 image */
//                background-repeat: no-repeat;
//                background-size: cover; /* Ensures the background image covers the whole area */
//                font-family: Arial, sans-serif;
//                font-size: 14px;
//                font-weight: bold;
//                position: relative;
//                height: 100vh; /* Full viewport height */
//                margin: 0;
//                padding: 0;
//            }
//            table {
//                width: 100%;
//                height: 100%;
//                position: absolute;
//                top: 0;
//                left: 0;
//                padding: 50px; /* Adjust padding to position content */
//                box-sizing: border-box;
//            }
//            .qr-code {
//                position: absolute;
//                bottom: 20px;
//                left: 20px;
//                width: 200px;
//                height: 200px;
//            }
//        </style>
//    </head>
//    <body>
//        <form id='form1' method='post'>
//            <table cellpadding='8px' cellspacing='0'>
//                <tr>
//                    <td style='padding-left:150px; width:70%;'>P</td>
//                    <td style='padding-left:155px'>P</td>
//                </tr>
//                <tr>
//                    <td style='padding-left:195px;'>G</td>
//                    <td style='padding-left:155px'>A</td>
//                </tr>
//                <tr>
//                    <td style='padding-left:360px;padding-top:185px;'>010</td>
//                    <td style='padding-left:140px' rowspan='2'>
//                        <img src='data:image/png;base64,null' height='120px' width='100px' style='margin-top:90px;' />
//                    </td>
//                </tr>
//                <tr>
//                    <td style='padding-left:320px;'>null</td>
//                </tr>
//                <tr>
//                    <td style='padding-left:180px;padding-top:35px;' colspan='2'>202420001</td>
//                </tr>
//                <tr>
//                    <td colspan='2'>
//                        <table width='100%' cellspacing='0' cellpadding='0'>
//                            <tr>
//                                <td style='padding-left:150px; width:45%;'>null</td>
//                                <td style='padding-left:10px;'>AMAR JEET KAUR</td>
//                            </tr>
//                        </table>
//                    </td>
//                </tr>
//                <tr>
//                    <td colspan='2'>
//                        <table width='100%' cellspacing='0' cellpadding='0'>
//                            <tr>
//                                <td style='padding-left:300px; width:60%;'></td>
//                            </tr>
//                        </table>
//                    </td>
//                </tr>
//                <tr>
//                    <td style='padding-left:290px;'>JAS BIR SINGH</td>
//                    <td>²Ó ÉÛÏ ÚÓâ®</td>
//                </tr>
//                <tr>
//                    <td colspan='2'>
//                        <table width='100%'>
//                            <tr>
//                                <td style='padding-left:100px; width:25%; padding-top:80px;'>BEANT KAUR</td>
//                                <td style='padding-top:80px; text-align:right;'>Éã¤â¼ ¨ïÏ</td>
//                                <td style='padding-left:100px;padding-top:11px; text-align:center;' rowspan='2'>
//                                    <img src='null' height='60px' width='200px' />
//                                </td>
//                            </tr>
//                        </table>
//                    </td>
//                </tr>
//            </table>
//            <div class='qr-code'>
//                <img src='data:image/png;base64,null' width='200' height='200' />
//            </div>
//        </form>
//    </body>
//    </html>
//   ''';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadHtmlWithImage();
//   }
//
//   Future<void> _loadHtmlWithImage() async {
//     // Load image from assets and convert to base64
//     final ByteData imageData = await rootBundle.load('assets/osstet.jpg');
//     final String base64Image = base64Encode(imageData.buffer.asUint8List());
//
//     // Replace the IMAGE_DATA placeholder with the base64 image data
//     setState(() {
//       htmlData = htmlData.replaceFirst(
//         'IMAGE_DATA',
//         'data:image/jpeg;base64,$base64Image',
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Display Certificate'),
//       ),
//       body: htmlData.contains('IMAGE_DATA')
//           ? Center(child: CircularProgressIndicator())
//           : WebView(
//         initialUrl: Uri.dataFromString(
//           htmlData,
//           mimeType: 'text/html',
//           encoding: Encoding.getByName('utf-8'),
//         ).toString(),
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }


