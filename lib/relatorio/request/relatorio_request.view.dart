import 'package:aws_mq_app/relatorio/request/pickers.exp.dart';
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

  static const double checkPadding = 32;
  static const double allPadding = 24;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: checkPadding),
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
              const SizedBox(height: allPadding),
              //
              // Métricas
              //
              Container(
                padding: const EdgeInsets.symmetric(horizontal: checkPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Métricas",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Divider(),
                    MyCheckTile(
                      texto: "Variância",
                      controlador: checkVariancia,
                      onChanged: ((bool? value) {
                        setState(() {
                          checkVariancia = value ?? false;
                        });
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: allPadding),
              //
              // Escala
              //
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
                },
              ),
              const SizedBox(height: allPadding),
              //
              // Data/Hora inicial e final
              // TODO: mudar para picker
              TextFormField(
                onChanged: (value) {
                  fieldInicialTemp = value;
                },
                decoration: const InputDecoration(
                  labelText: "Inicial",
                ),
              ),
              const SizedBox(height: allPadding),
              TextFormField(
                onChanged: (value) {
                  fieldFinalTemp = value;
                },
                decoration: const InputDecoration(
                  hintText: "Final",
                  labelText: "Final",
                ),
              ),
              const SizedBox(height: allPadding + 16),
              //
              // Submit
              //
              ElevatedButton(
                  onPressed: () {
                    _formkey.currentState!.validate();
                    if (kDebugMode) {
                      print(checkPh);
                      print(checkTemp);
                      print(checkLum);
                      print(checkVariancia);
                      print(dropdownEscala);
                      print(fieldInicialTemp);
                      print(fieldFinalTemp);
                    }
                    // TODO: enviar para o broker
                  },
                  child: const Text("Enviar"))
            ],
          ),
        ),
      ),
    );
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
