import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom HTML Parser')),
        body: HtmlToWidgets(
          htmlData: "<h1>Hello, Worlddfgdfgdf!</h1><p>This is a paragraph.</p>",
        ),
      ),
    );
  }
}

class HtmlToWidgets extends StatelessWidget {
  final String htmlData;

  HtmlToWidgets({required this.htmlData});

  @override
  Widget build(BuildContext context) {
    var document = html_parser.parse(htmlData);
    List<Widget> widgets = [];

    document.body?.children.forEach((element) {
      if (element.localName == 'h1') {
        widgets.add(Text(
          element.text,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ));
      } else if (element.localName == 'p') {
        widgets.add(Text(element.text));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
