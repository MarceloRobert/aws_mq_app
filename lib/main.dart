import 'package:flutter/material.dart';

import 'home/home.view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidroponia',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}