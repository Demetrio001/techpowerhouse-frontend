import 'package:flutter/material.dart';
import 'UI/pages/layout.dart';
import 'model/supports/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:  Layout(),
    );
  }
}