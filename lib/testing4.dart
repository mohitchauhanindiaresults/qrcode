import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanner_app/testing3.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Testing_four extends StatefulWidget {
  final String htmlData;

  Testing_four({required this.htmlData});

  @override
  State<Testing_four> createState() => _Testing_fourState();
}

class _Testing_fourState extends State<Testing_four> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          // Check if WebView can go back
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false; // Don't close the screen
          } else {
            // If WebView can't go back, navigate to the desired screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QRScanScreen()),
            );
            return true; // Allow navigation to close the screen
          }
        },
        child: FullScreenWebView(
          htmlData: widget.htmlData,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}

class FullScreenWebView extends StatelessWidget {
  final String htmlData;
  final Function(WebViewController) onWebViewCreated;

  FullScreenWebView({required this.htmlData, required this.onWebViewCreated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen WebView'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: WebView(
        initialUrl: Uri.dataFromString(
          htmlData,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          onWebViewCreated(controller); // Pass the controller to the parent widget
        },
      ),
    );
  }
}
