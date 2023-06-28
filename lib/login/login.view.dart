import 'dart:async';
import 'dart:convert';

import 'package:hidroponia/shared/app.shared.dart';
import 'package:hidroponia/shared/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  int? lastDataHashStream;
  int? lastErrorHashStream;

  Map<String, String> userCredentials = {
    "username": "",
    "password": "",
  };
  Map<String, dynamic> loginReplyData = {};

  final StreamController _loginReplyStream = StreamController();
  bool waitingReply = false;
  late Function loginReplyUnsub;

  static const double inbetweenSpacing = 24;

  @override
  void initState() {
    super.initState();
    if (sharedSocket.stompClient.connected == false) {
      if (kDebugMode) {
        print("LoginPage: Sem conexão");
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        sharedSMS.currentState?.showSnackBar(const SnackBar(
          content: Text("Sem conexão"),
        ));

        Navigator.pushReplacementNamed(context, '/landing');
      });
    } else {
      loginReplyUnsub =
          sharedSocket.subscribeToTopic('login_reply', _loginReplyStream);
    }
  }

  @override
  void dispose() {
    loginReplyUnsub();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _loginReplyStream.stream,
        builder: (context, snapshot) {
          // Trata erro da stream
          if (snapshot.hasError) {
            if (lastErrorHashStream == null ||
                lastErrorHashStream != snapshot.error.hashCode) {
              lastErrorHashStream ??= snapshot.error.hashCode;
              if (kDebugMode) {
                print("Login snapshot error:");
                print(snapshot.error);
              }
              loginReplyData = jsonDecode(snapshot.error as String);
              if (loginReplyData['err_id'] != null &&
                  loginReplyData['err_desc'] != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorAlert(
                      theError: MyErrors.fromJson(loginReplyData),
                    ),
                  );
                });
              }
              waitingReply = false;
            }
          }

          // Trata respostas do login
          if (snapshot.hasData) {
            if (lastDataHashStream == null ||
                lastDataHashStream != snapshot.data.hashCode) {
              lastDataHashStream ??= snapshot.data.hashCode;
              if (kDebugMode) {
                print("Login snapshot data:");
                print(snapshot.data);
              }
              try {
                loginReplyData = jsonDecode(snapshot.data);
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              } finally {
                if (loginReplyData['cli_id'] != null &&
                    loginReplyData['equipamento'] != null &&
                    loginReplyData['amb_id'] != null) {
                  sharedUser["cli_id"] = loginReplyData["cli_id"];
                  sharedUser["equipamento"] = loginReplyData["equipamento"];
                  sharedUser["amb_id"] = loginReplyData["amb_id"];
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                }
                waitingReply = false;
              }
            }
          }

          if (kDebugMode) {
            print("-----Login-----");
          }
          // Desenha a tela
          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: inbetweenSpacing * 2,
                children: [
                  //
                  // Logo
                  //
                  Hero(
                    tag: 'mainLogo',
                    child: SizedBox.square(
                      dimension: 200,
                      child: Image.asset(
                        'lib/assets/logoCutTransparent.png',
                        fit: BoxFit.contain,
                        semanticLabel: "Logo Hidroponia",
                      ),
                    ),
                  ),
                  //
                  // Campos de texto
                  //
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
                            userCredentials["username"] = value;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Senha",
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            userCredentials["password"] = value;
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Valor não pode ser vazio.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //
                  // Botões
                  //
                  Wrap(
                    runSpacing: inbetweenSpacing / 2,
                    children: [
                      // Enviar forms
                      waitingReply == false
                          ? ElevatedButton(
                              style: const ButtonStyle(
                                minimumSize: MaterialStatePropertyAll(
                                  Size(double.infinity, 38),
                                ),
                              ),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  sharedSocket.sendMessage(
                                      jsonEncode(userCredentials),
                                      'login_request');
                                  waitingReply = true;
                                  setState(() {});
                                }
                              },
                              child: !waitingReply
                                  ? const Text("Login")
                                  : const CircularProgressIndicator(),
                            )
                          : const Center(child: CircularProgressIndicator()),
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
                      ),
                    ],
                  ),
                  //
                  // Créditos
                  //
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                              "https://pt.vecteezy.com/vetor-gratis/hidroponia"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const Text(
                        "Hidroponia Vetores por Vecteezy",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
