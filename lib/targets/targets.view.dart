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
                    phTarget = double.tryParse(value);
                    if (phTarget == null) {
                      return "Formato inválido";
                    }
                    if (phTarget! < limitephMinimo) {
                      return "Valor muito pequeno";
                    }
                    if (phTarget! > limitephMaximo) {
                      return "Valor muito grande";
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
                    tempMinima = int.tryParse(value);
                    if (tempMinima == null) {
                      return "Formato inválido";
                    }
                    if (tempMaxima != null && tempMinima! > tempMaxima!) {
                      return "Maior que o máximo";
                    }
                    if (tempMinima! < limiteTempMinimo) {
                      return "Valor muito pequeno";
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
                    tempMaxima = int.tryParse(value);
                    if (tempMaxima == null) {
                      return "Formato inválido";
                    }
                    if (tempMinima != null &&
                        int.tryParse(value)! < tempMinima!) {
                      return "Menor que o mínimo";
                    }
                    if (tempMaxima! > limiteTempMaximo) {
                      return "Valor muito alto";
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
                  _formkey.currentState!.validate();
                  if (phTarget != null &&
                      tempMinima != null &&
                      tempMaxima != null) {
                    // TODO: juntar e enviar os dados
                    if (kDebugMode) {
                      print("Enviando...");
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
