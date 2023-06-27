import 'dart:async';
import 'dart:convert';

import 'package:hidroponia/shared/app.shared.dart';
import 'package:hidroponia/shared/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? errResult;

  final StreamController _varStream = StreamController();
  int? lastHashStream;
  late Function varStreamUnsub;
  Map<String, dynamic> valoresStream = {};

  final StreamController _alertaStream = StreamController();
  late Function alertaStreamUnsub;

  @override
  void initState() {
    super.initState();
    if (sharedSocket.stompClient.connected == true) {
      if (sharedUser["uuid"] != "") {
        varStreamUnsub = sharedSocket.subscribeToTopic(
          '${sharedUser["equipamento"]}.var_stream',
          _varStream,
        );
        alertaStreamUnsub = sharedSocket.subscribeToTopic(
          '${sharedUser["equipamento"]}.alerta',
          _alertaStream,
        );
      }
    }
  }

  @override
  void dispose() {
    varStreamUnsub();
    alertaStreamUnsub();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _alertaStream.stream,
        builder: (context, snapshot) {
          // Trata erro da stream
          if (snapshot.hasError) {
            if (kDebugMode) {
              print("Home snapshot error:");
              print(snapshot.error);
            }
            Map<String, dynamic> streamError =
                jsonDecode(snapshot.error as String);
            if (streamError['err_id'] != null &&
                streamError['err_desc'] != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorAlert(
                    theError: MyErrors.fromJson(streamError),
                  ),
                );
              });
            }
          }

          if (snapshot.hasData) {
            if (lastHashStream == null ||
                snapshot.data.hashCode != lastHashStream) {
              lastHashStream ??= snapshot.data.hashCode;
              if (kDebugMode) {
                print("Home snapshot data:");
                print(snapshot.data);
              }
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorAlert(
                      theError: MyErrors.fromJson(
                        {
                          "err_id": 5,
                          "err_desc":
                              "A variável ${snapshot.data.toString()} está fora do objetivo!",
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }

          if (kDebugMode) {
            print("-----Home-----");
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Hidroponia"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.exit_to_app_rounded, size: 32),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 48,
                runSpacing: 48,
                children: [
                  Hero(
                    tag: 'mainLogo',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SizedBox.square(
                        dimension: 200,
                        child: Image.asset(
                          'lib/assets/logoCutTransparent.png',
                          fit: BoxFit.contain,
                          semanticLabel: "Logo Hidroponia",
                        ),
                      ),
                    ),
                  ),
                  //
                  // Dados que foram recebidos
                  //
                  StreamBuilder(
                      stream: _varStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          valoresStream = jsonDecode(snapshot.data);
                        }

                        return Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            const TableRow(
                              children: [
                                SizedBox(),
                                Text(
                                  "Atual",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Objetivo",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                ...dataReceivedWidgets(context,
                                    titulo: "pH 💧",
                                    valorAtual: valoresStream["ph_atual"] ?? "",
                                    valorObjetivo:
                                        valoresStream["ph_target"] ?? ""),
                              ],
                            ),
                            TableRow(
                              children: [
                                ...dataReceivedWidgets(context,
                                    titulo: "Temp 🌡",
                                    valorAtual:
                                        valoresStream["temp_atual"] ?? "",
                                    valorObjetivo:
                                        "${valoresStream["temp_min"] ?? ""} ~ ${valoresStream["temp_max"] ?? ""}"),
                              ],
                            ),
                            TableRow(
                              children: [
                                ...dataReceivedWidgets(context,
                                    titulo: "Lumin 💡",
                                    valorAtual:
                                        valoresStream["lum_atual"] ?? "",
                                    valorObjetivo: "-"),
                              ],
                            ),
                          ],
                        );
                      }),
                  //
                  // Mudar Objetivos
                  //
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/targets');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.primary),
                          ),
                          child: Text(
                            "Alterar dados Objetivos",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/relatorio/request');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).colorScheme.primary),
                          ),
                          child: Text(
                            "Solicitar Relatório",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

List<Widget> dataReceivedWidgets(
  BuildContext context, {
  required String titulo,
  required String valorAtual,
  required String valorObjetivo,
}) {
  const double textSize = 18;
  return [
    Text(
      titulo,
      style: const TextStyle(fontSize: textSize),
      textAlign: TextAlign.end,
    ),
    Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        //
        child: Text(
          valorAtual,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: textSize,
          ),
          textAlign: TextAlign.center,
        )),
    //
    Text(
      valorObjetivo,
      style: const TextStyle(
        fontSize: textSize,
      ),
      textAlign: TextAlign.center,
    ),
  ];
}
