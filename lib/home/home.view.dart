import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../service_stomp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? errResult;
  StompServices socket = StompServices();
  final StreamController _somaStream = StreamController();
  final StreamController _mensagemStream = StreamController();
  final StreamController _arquivoStream = StreamController();

  bool connected = false;
  bool listening = false;
  String topic = "messageInput";

  @override
  void initState() {
    super.initState();
    // socket.stompClient.activate();
    connected = true;
  }

  @override
  void dispose() {
    if (socket.stompClient.connected) {
      socket.stompClient.deactivate();
      if (kDebugMode) {
        print("Disconnected");
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                ),
              ),
            ),
            //
            // Dados que foram recebidos
            //
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                    ...dataReceivedWidgets(
                      context,
                      titulo: "pH 💧",
                      streamAtual: "6.8",
                      streamObjetivo: "7.0",
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ...dataReceivedWidgets(
                      context,
                      titulo: "Temp 🌡",
                      streamAtual: "19",
                      streamObjetivo: "20",
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ...dataReceivedWidgets(
                      context,
                      titulo: "Lumin 💡",
                      streamAtual: "600",
                      streamObjetivo: "600",
                    ),
                  ],
                ),
              ],
            ),
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
  }
}

// TODO: usar as streams
List<Widget> dataReceivedWidgets(
  BuildContext context, {
  required String titulo,
  required String streamAtual,
  required streamObjetivo,
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
      // TODO: trocar para stream
      child: Text(
        streamAtual,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: textSize,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    // TODO: trocar para stream
    Text(
      streamObjetivo,
      style: const TextStyle(
        fontSize: textSize,
      ),
      textAlign: TextAlign.center,
    ),
  ];
}

class ReceivedData extends StatelessWidget {
  final String titulo;
  final String streamAtual;
  final String streamObjetivo;
  final double spacing;

  const ReceivedData({
    super.key,
    required this.titulo,
    required this.streamAtual,
    required this.streamObjetivo,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 24),
        ),
        SizedBox(width: spacing),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.secondary.withAlpha(128),
          ),
          // TODO: trocar para stream
          child: Text(
            streamAtual,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(width: spacing),
        // TODO: trocar para stream
        Text(
          streamObjetivo,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
