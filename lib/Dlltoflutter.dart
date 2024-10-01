import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Define the signature of the function you're calling from the DLL
typedef MyFunctionC = Int32 Function();
typedef MyFunctionDart = int Function();

// Load and call the DLL function
void main() {
  // Path to your DLL file (adjust the path accordingly)
  final dylib = DynamicLibrary.open('assets/my.dll');

  // Lookup a function from the DLL
  final MyFunctionDart myFunction = dylib
      .lookup<NativeFunction<MyFunctionC>>('CompressedNumberToBase64')
      .asFunction<MyFunctionDart>();

  // Call the function and print the result
  final result = myFunction();
  print('Function result: $result');
}
