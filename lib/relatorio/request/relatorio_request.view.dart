import 'dart:async';
import 'dart:convert';

import 'package:hidroponia/relatorio/reply/relatorio_reply.view.dart';
import 'package:hidroponia/shared/app.shared.dart';
import 'package:hidroponia/shared/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RelatorioRequestPage extends StatefulWidget {
  const RelatorioRequestPage({super.key});

  @override
  State<RelatorioRequestPage> createState() => _RelatorioRequestPageState();
}

class _RelatorioRequestPageState extends State<RelatorioRequestPage> {
  final _formkey = GlobalKey<FormState>();

  bool checkPh = false;
  bool checkTemp = false;
  bool checkLum = false;
  bool checkVariancia = false;
  String dropdownEscala = "Horas";
  String fieldInicialTemp = "";
  String fieldFinalTemp = "";
  String dataReferenciaTemp = "";

  static const double checkPadding = 32;
  static const double inbetweenPadding = 24;

  Map<String, dynamic> relatorioRequestData = {
    // "vars": [], // "temperatura", "ph", "luminosidade"
    // "data_inicial": "", // 14/06/23, null se for horas
    // "data_final": "", // 14/06/23, null se for horas
    // "data_ref": "", //14/06/23, null se for dias
    // "hora_inicial": null, // null se for dias
    // "hora_final": null, // null se for dias
    // "escala": "", // "dias"/"horas"
    // "requester_id": ""
  };

  final StreamController _relatorioReplyStream = StreamController();
  bool waitingReply = false;
  late Function relatorioReplyUnsub;
  Map<String, dynamic> streamError = {};

  Map<String, dynamic> replyData = {};

  @override
  void initState() {
    super.initState();
    relatorioReplyUnsub =
        sharedSocket.subscribeToTopic("relatorio_reply", _relatorioReplyStream);
  }

  @override
  void dispose() {
    relatorioReplyUnsub();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _relatorioReplyStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print("Relatorio snapshot error:");
              print(snapshot.error);
            }
            streamError = jsonDecode(snapshot.error as String);
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
            waitingReply = false;
          }

          if (snapshot.hasData) {
            try {
              replyData = jsonDecode(snapshot.data);
                if (kDebugMode) {
                  print("Relatorio snapshot data:");
                  print(replyData);
                }
                waitingReply = false;
                replyData.addAll(relatorioRequestData);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelatorioReplyPage(dadosView: replyData),
                      ));
                });
            } catch (e) {
              // recebe os dados para tirar da stream
              // ignore: unused_local_variable
              var trashData = snapshot.data;
              if (kDebugMode) {
                print("Erro em Relatório Request:");
                print(e);
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Solicitar Relatório"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //
                    // Dados
                    //
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: checkPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Dados",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Divider(),
                          MyCheckTile(
                            texto: "pH",
                            controlador: checkPh,
                            onChanged: ((bool? value) {
                              setState(() {
                                checkPh = value ?? false;
                              });
                            }),
                          ),
                          MyCheckTile(
                            texto: "Temperatura",
                            controlador: checkTemp,
                            onChanged: ((bool? value) {
                              setState(() {
                                checkTemp = value ?? false;
                              });
                            }),
                          ),
                          MyCheckTile(
                            texto: "Luminosidade",
                            controlador: checkLum,
                            onChanged: ((bool? value) {
                              setState(() {
                                checkLum = value ?? false;
                              });
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: inbetweenPadding),
                    // //
                    // // Métricas
                    // //
                    // Container(
                    //   padding:
                    //       const EdgeInsets.symmetric(horizontal: checkPadding),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       const Text(
                    //         "Métricas",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 18),
                    //       ),
                    //       const Divider(),
                    //       MyCheckTile(
                    //         texto: "Variância",
                    //         controlador: checkVariancia,
                    //         onChanged: ((bool? value) {
                    //           setState(() {
                    //             checkVariancia = value ?? false;
                    //           });
                    //         }),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: inbetweenPadding),
                    // //
                    // // Escala
                    // //
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        hintText: "Escala",
                        labelText: "Escala",
                      ),
                      value: dropdownEscala,
                      items: const [
                        DropdownMenuItem(
                          value: "Horas",
                          child: Text("Horas"),
                        ),
                        DropdownMenuItem(
                          value: "Dias",
                          child: Text("Dias"),
                        ),
                      ],
                      onChanged: (String? valor) {
                        dropdownEscala = valor ?? "Horas";
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: inbetweenPadding),
                    //
                    // Data/Hora inicial e final
                    // TODO: mudar para picker ou combinar formato
                    if (dropdownEscala == "Horas")
                      TextFormField(
                        onChanged: (value) {
                          dataReferenciaTemp = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "Data de referência",
                          labelText: "Data de referência",
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Insira um valor";
                          }
                          return null;
                        },
                      ),
                    if (dropdownEscala == "Horas")
                      const SizedBox(height: inbetweenPadding),
                    TextFormField(
                      onChanged: (value) {
                        fieldInicialTemp = value;
                      },
                      decoration: const InputDecoration(
                        hintText: "Inicial",
                        labelText: "Inicial",
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Insira um valor";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: inbetweenPadding),
                    TextFormField(
                      onChanged: (value) {
                        fieldFinalTemp = value;
                      },
                      decoration: const InputDecoration(
                        hintText: "Final",
                        labelText: "Final",
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Insira um valor";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: inbetweenPadding + 16),
                    //
                    // Submit
                    //
                    waitingReply == false
                        ? ElevatedButton(
                            onPressed: () {
                              if (waitingReply == false) {
                                if (_formkey.currentState!.validate() &&
                                    (checkPh != false ||
                                        checkTemp != false ||
                                        checkLum != false)) {
                                  relatorioRequestData["vars"] = [];
                                  if (checkPh) {
                                    relatorioRequestData["vars"].add("ph");
                                  }
                                  if (checkTemp) {
                                    relatorioRequestData["vars"]
                                        .add("temperatura");
                                  }
                                  if (checkLum) {
                                    relatorioRequestData["vars"]
                                        .add("luminosidade");
                                  }
                                  if (dropdownEscala == "Horas") {
                                    relatorioRequestData["escala"] = "horas";
                                    relatorioRequestData["data_ref"] =
                                        dataReferenciaTemp;
                                    relatorioRequestData["hora_inicial"] =
                                        fieldInicialTemp;
                                    relatorioRequestData["hora_final"] =
                                        fieldFinalTemp;
                                  } else {
                                    relatorioRequestData["escala"] = "dias";
                                    relatorioRequestData["data_inicial"] =
                                        fieldInicialTemp;
                                    relatorioRequestData["data_final"] =
                                        fieldFinalTemp;
                                  }

                                  relatorioRequestData["amb_id"] =
                                      sharedUser["amb_id"];
                                  relatorioRequestData["cli_id"] =
                                      sharedUser["cli_id"];
                                  if (kDebugMode) {
                                    print(relatorioRequestData.toString());
                                  }
                                  sharedSocket.sendMessage(
                                      jsonEncode(relatorioRequestData),
                                      "relatorio_request");
                                  waitingReply = true;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Solicitando relatório. Permaneça na página"),
                                    ),
                                  );
                                  setState(() {});
                                }
                              }
                            },
                            child: const Text("Enviar"),
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MyCheckTile extends StatefulWidget {
  const MyCheckTile({
    super.key,
    required this.texto,
    required this.controlador,
    required this.onChanged,
  });

  final String texto;
  final bool controlador;
  final Function(bool?) onChanged;

  @override
  State<MyCheckTile> createState() => _MyCheckTileState();
}

class _MyCheckTileState extends State<MyCheckTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.texto),
      value: widget.controlador,
      onChanged: widget.onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      checkboxShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}
