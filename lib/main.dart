import 'package:flutter/material.dart';
import 'package:web_browser/browser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Web',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BrowserPage());
  }
}
