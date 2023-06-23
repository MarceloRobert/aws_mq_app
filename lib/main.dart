import 'package:aws_mq_app/home/home.view.dart';
import 'package:aws_mq_app/login/login.view.dart';
import 'package:aws_mq_app/relatorio/request/relatorio_request.view.dart';
import 'package:aws_mq_app/targets/targets.view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hidroponia',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const LoginPage(),
      routes: {
        "/login": (context) => const LoginPage(),
        "/home": (context) => const HomePage(),
        "/relatorio/request": (context) => const RelatorioRequestPage(),
        "/targets": (context) => const TargetsPage(),
      },
    );
  }
}
