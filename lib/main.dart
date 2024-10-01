import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_app/SpalshScreen.dart';
import 'package:scanner_app/Testing.dart';

//import 'firebase_options.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gunotsav',
      debugShowCheckedModeBanner: false,
      // routes: AppRoutes.routes,
      // theme: appTheme,
      home: MyHomePageeeeeeeeeeeee(),
    );
  }
}
