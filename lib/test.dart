//
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// String decompressString(Uint8List compressedData) {
//   // Create a ZLibCodec object for decompression (ZLib includes GZip functionality)
//   final zlibCodec = ZLibCodec();
//
//   // Decompress the data
//   final decompressedData = zlibCodec.decode(compressedData);
//
//   // Convert the decompressed byte array back to a string
//   return utf8.decode(decompressedData);
// }
//
// void main() {
//   // Example compressed data (Uint8List)
//   Uint8List compressedData = /* Your compressed byte array here */;
//
//   // Decompress the data
//   String decompressedString = decompressString(compressedData);
//
//   print("Decompressed String: $decompressedString");
// }
//
// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:typed_data';
// //
// // // Compress a string to a GZip compressed byte array
// // Uint8List compressString(String data) {
// //   // Convert the string to a UTF-8 byte array
// //   final inputBytes = utf8.encode(data);
// //
// //   // Create a GZipCodec object for compression
// //   final gzipCodec = GZipCodec();
// //
// //   // Compress the data
// //   return Uint8List.fromList(gzipCodec.encode(inputBytes));
// // }
// //
// // // Decompress a GZip compressed byte array back to a string
// // String decompressString(Uint8List compressedData) {
// //   // Create a GZipCodec object for decompression
// //   final gzipCodec = GZipCodec();
// //
// //   // Decompress the data
// //   final decompressedData = gzipCodec.decode(compressedData);
// //
// //   // Convert the decompressed byte array back to a string
// //   return utf8.decode(decompressedData);
// // }
// //
// // void main() {
// //   // Example string to compress
// //   String originalString = "This is the data to be compressed and decompressed.";
// //
// //   // Compress the string
// //   Uint8List compressedData = compressString(originalString);
// //   print("Compressed Data: $compressedData");
// //
// //
// //   //Decompress the data back to a string
// //   String decompressedString = decompressString(compressedData);
// //   print("Decompressed String: $decompressedString");
// //
// //   // Verify the original string matches the decompressed string
// // assert(originalString == decompressedString);
// // }
import 'dart:convert';
import 'dart:typed_data';

Uint8List compressedNumberToBase64Data(String compressedNumberStr) {
  // Step 1: Convert the string to BigInt
  BigInt compressedNumber = BigInt.parse(compressedNumberStr);

  // Step 2: Convert the BigInt to a byte array (Uint8List)
  Uint8List byteArray = bigIntToBytes(compressedNumber);

  // Step 3: Remove the leading zero byte if present (for unsigned representation)
  if (byteArray.isNotEmpty && byteArray[byteArray.length - 1] == 0) {
    byteArray = Uint8List.fromList(byteArray.sublist(0, byteArray.length - 1));
  }

  // Step 4: Encode the byte array into Base64 and then decode back into bytes
  return base64Decode(base64Encode(byteArray));
}

/// Helper function to convert BigInt to byte array (Uint8List)
Uint8List bigIntToBytes(BigInt number) {
  var bytes = number.toUnsigned(8 * ((number.bitLength + 7) >> 3)).toRadixString(16);
  if (bytes.length % 2 == 1) {
    bytes = '0' + bytes; // Ensure even length for hex string
  }
  return Uint8List.fromList(List<int>.generate(bytes.length ~/ 2, (i) {
    return int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16);
  }));
}

void main() {
  String compressedNumberStr = "12345678901234567890"; // Example compressed number
  Uint8List result = compressedNumberToBase64Data(compressedNumberStr);

  print(result); // Output the result as a byte array
}