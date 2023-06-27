import 'package:hidroponia/home/home.view.dart';
import 'package:hidroponia/landing/landing.view.dart';
import 'package:hidroponia/login/login.view.dart';
import 'package:hidroponia/relatorio/reply/relatorio_reply.view.dart';
import 'package:hidroponia/relatorio/request/relatorio_request.view.dart';
import 'package:hidroponia/shared/app.shared.dart';
import 'package:hidroponia/targets/targets.view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: sharedSMS,
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
      home: const LandingPage(),
      routes: {
        "/landing": (context) => const LandingPage(),
        "/login": (context) => const LoginPage(),
        "/home": (context) => const HomePage(),
        "/relatorio/request": (context) => const RelatorioRequestPage(),
        "/relatorio/reply": (context) => const RelatorioReplyPage(
              dadosView: {},
            ),
        "/targets": (context) => const TargetsPage(),
      },
    );
  }
}
