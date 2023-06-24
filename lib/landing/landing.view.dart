import 'package:aws_mq_app/credentials.dart';
import 'package:aws_mq_app/shared/app.shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? newUsername;
  String? newPasscode;
  String? newEndpoint;
  Future? socketConnection;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    socketConnection = sharedSocket.makeConnection();
  }

  @override
  Widget build(BuildContext context) {
    // Pode ser modificado para um StreamBuilder
    // TODO: verificar se é melhor usar stream
    return FutureBuilder(
      future: socketConnection,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          sharedSocket.revokeConnection();
          return Scaffold(
            floatingActionButton: IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("bypassing");
                }
                setState(() {
                  socketConnection = sharedSocket.connectDebug();
                });
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
              padding: const EdgeInsets.all(64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  // Mensagens e botões principais
                  //
                  Wrap(
                    runSpacing: 24,
                    children: [
                      const Text(
                        "Ops! Ocorreu um erro ao se conectar com o servidor. Tente novamente mais tarde.",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(
                            Size(double.infinity, 38),
                          ),
                        ),
                        onPressed: () async {
                          // retry with override
                          if (newUsername != null && newUsername != "") {
                            userAppCredential = newUsername!;
                          }
                          if (newPasscode != null && newPasscode != "") {
                            passcodeAppCredential = newPasscode!;
                          }
                          if (newEndpoint != null && newEndpoint != "") {
                            endpointAppCredential = newEndpoint!;
                          }
                          // Assegura que não está conectado antes de tentar nova conexão
                          await sharedSocket.revokeConnection();
                          setState(() {
                            socketConnection = Future(() => null);
                            socketConnection = sharedSocket.makeConnection();
                          });
                        },
                        child: const Text("Conectar novamente"),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Erro: ",
                            ),
                            TextSpan(text: snapshot.error.toString()),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  //
                  // Form override
                  //
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 64, horizontal: 0),
                    child: Divider(
                      height: 4,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Form(
                    key: _formkey,
                    child: Wrap(
                      runSpacing: 8,
                      children: [
                        const Text(
                          "Override das credenciais",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            newUsername = value;
                          },
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            newPasscode = value;
                          },
                          decoration: const InputDecoration(
                            hintText: "Passcode",
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            newEndpoint = value;
                          },
                          decoration: const InputDecoration(
                            hintText: "Endpoint",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
