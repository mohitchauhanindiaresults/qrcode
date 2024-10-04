import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Testing_four extends StatefulWidget {

  final String htmlData;

  Testing_four({required this.htmlData});

  @override
  State<Testing_four> createState() => _Testing_fourState();
}

class _Testing_fourState extends State<Testing_four> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FullScreenWebView(htmlData: widget.htmlData,),
    );
  }
}

class FullScreenWebView extends StatelessWidget {
  final String htmlData;

  FullScreenWebView({required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen WebView'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(htmlData, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
