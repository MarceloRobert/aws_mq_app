import 'dart:convert';

import 'package:hidroponia/shared/app.shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TargetsPage extends StatefulWidget {
  const TargetsPage({super.key});

  @override
  State<TargetsPage> createState() => _TargetsPageState();
}

class _TargetsPageState extends State<TargetsPage> {
  final _formkey = GlobalKey<FormState>();

  double? phTarget;
  int? tempMinima;
  int? tempMaxima;
  static const double limitephMinimo = 0;
  static const double limitephMaximo = 14;
  static const int limiteTempMinimo = 5;
  static const int limiteTempMaximo = 40;

  static const double inbetweenPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alterar objetivos"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              // ph
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "pH objetivo",
                ),
                validator: (value) {
                  if (value != null) {
                    if (value != "") {
                      phTarget = double.tryParse(value);
                      if (phTarget == null) {
                        return "Formato inválido";
                      }
                      if (phTarget! < limitephMinimo) {
                        phTarget = null;
                        return "Valor muito pequeno";
                      }
                      if (phTarget! > limitephMaximo) {
                        phTarget = null;
                        return "Valor muito grande";
                      }
                    } else {
                      phTarget = null;
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: inbetweenPadding),
              // temp mínima
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Objetivo de temperatura mínima",
                ),
                validator: (value) {
                  if (value != null) {
                    if (value != "") {
                      tempMinima = int.tryParse(value);
                      if (tempMinima == null) {
                        return "Formato inválido";
                      }
                      if (tempMaxima != null && tempMinima! > tempMaxima!) {
                        tempMinima = null;
                        return "Maior que o máximo";
                      }
                      if (tempMinima! < limiteTempMinimo) {
                        tempMinima = null;
                        return "Valor muito pequeno";
                      }
                    } else {
                      tempMinima = null;
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: inbetweenPadding),
              // temp máxima
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Objetivo de temperatura máxima",
                ),
                validator: (value) {
                  if (value != null) {
                    if (value != "") {
                      tempMaxima = int.tryParse(value);
                      if (tempMaxima == null) {
                        return "Formato inválido";
                      }
                      if (tempMinima != null &&
                          int.tryParse(value)! < tempMinima!) {
                        tempMaxima = null;
                        return "Menor que o mínimo";
                      }
                      if (tempMaxima! > limiteTempMaximo) {
                        tempMaxima = null;
                        return "Valor muito alto";
                      }
                    } else {
                      tempMaxima = null;
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: inbetweenPadding),
              // submit
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    // enviando ph
                    if (phTarget != null) {
                      if (kDebugMode) {
                        print("Enviando phTarget:");
                        print(phTarget);
                      }
                      sharedSocket.sendMessage(
                        jsonEncode({
                          "cli_id": sharedUser["cli_id"],
                          "amb_id": sharedUser["amb_id"],
                          "ph_target": phTarget.toString(),
                        }),
                        "${sharedUser["equipamento"]}.ph_set",
                      );
                      sharedSMS.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text("Enviando pH objetivo"),
                        ),
                      );
                    }

                    // enviando temperatura
                    if (tempMinima != null && tempMaxima != null) {
                      if (kDebugMode) {
                        print("Enviando tempTarget:");
                        print(tempMinima);
                        print(tempMaxima);
                      }
                      sharedSocket.sendMessage(
                        jsonEncode({
                          "cli_id": sharedUser["cli_id"],
                          "amb_id": sharedUser["amb_id"],
                          "temp_min": tempMinima.toString(),
                          "temp_max": tempMaxima.toString(),
                        }),
                        "${sharedUser["equipamento"]}.temp_set",
                      );
                      sharedSMS.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text("Enviando temperatura objetivo"),
                        ),
                      );
                    } else if (tempMinima != null || tempMaxima != null) {
                      sharedSMS.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Ambas temperaturas objetivo devem ser definidas!"),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Enviar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
