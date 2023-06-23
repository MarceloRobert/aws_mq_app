import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? userName;
  String? userPassword;

  static const double inbetweenSpacing = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 64,
        child: TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse("https://pt.vecteezy.com/vetor-gratis/hidroponia"),
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text("Hidroponia Vetores por Vecteezy"),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        icon: const Icon(Icons.link),
        iconSize: 32,
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.onPrimary,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Hero(
              tag: 'mainLogo',
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox.square(
                  dimension: 200,
                  child: Image.asset(
                    'lib/assets/logoCutTransparent.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nome de usuário",
                        ),
                        validator: (value) {
                          if (value != null && value.contains(" ")) {
                            return "Usuário inválido.";
                          } else if (value == "") {
                            return "Valor não pode ser vazio.";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                      const SizedBox(height: inbetweenSpacing),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Senha",
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          userPassword = value;
                        },
                        validator: (value) {
                          if (value == "") {
                            return "Valor não pode ser vazio.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: inbetweenSpacing),
                      ElevatedButton(
                        style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(
                            Size(double.infinity, 36),
                          ),
                        ),
                        onPressed: () {
                          print(_formkey.currentState!.validate());
                          print(userName);
                          print(userPassword);
                        },
                        child: const Text("Login"),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Esqueci a senha"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Registrar"),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
