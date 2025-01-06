import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> saveStringToPrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getStringFromPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  static void progressbar(BuildContext context,int) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          child: SpinKitFadingCircle(
            color: Color(int),
            size: 50.0,
          ),
          onWillPop: () async => false,
        );
      },
    );
  }

}