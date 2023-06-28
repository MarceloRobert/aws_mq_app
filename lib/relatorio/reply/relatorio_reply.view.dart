import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RelatorioReplyPage extends StatefulWidget {
  final Map<dynamic, dynamic> dadosView;
  const RelatorioReplyPage({super.key, required this.dadosView});

  @override
  State<RelatorioReplyPage> createState() => _RelatorioReplyPageState();
}

class _RelatorioReplyPageState extends State<RelatorioReplyPage> {
  List dadosPh = [];
  List dadosTemp = [];
  List dadosLum = [];

  static const double textFontSize = 18;

  @override
  void initState() {
    super.initState();
    if (widget.dadosView["phAtual"] != null) {
      dadosPh = widget.dadosView["phAtual"];
    }
    if (widget.dadosView["tempAtual"] != null) {
      dadosTemp = widget.dadosView["tempAtual"];
    }
    if (widget.dadosView["lumAtual"] != null) {
      dadosLum = widget.dadosView["lumAtual"];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Dados para visualização:");
      print(widget.dadosView);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatório"),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          runSpacing: 24,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            // Título do relatório
            if (widget.dadosView["escala"] == "dias")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Relatório de dados para o intervalo entre ${widget.dadosView["data_inicial"]} e ${widget.dadosView["data_final"]}",
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            if (widget.dadosView["escala"] == "horas")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Relatório de dados para o intervalo entre ${widget.dadosView["hora_inicial"]} e ${widget.dadosView["hora_final"]} do dia ${widget.dadosView["data_ref"]}",
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            // Dados ph
            if (dadosPh != [])
              MyLineChart(
                valueList: dadosPh,
                textFontSize: textFontSize,
                titulo: "Dados do pH:",
                ymin: 0,
                ymax: 14,
              ),
            // Dados temperatura
            if (dadosTemp != [])
              MyLineChart(
                valueList: dadosTemp,
                textFontSize: textFontSize,
                titulo: "Dados da temperatura:",
                ymin: 15,
                ymax: 45,
              ),
            // Dados luminosidade
            if (dadosLum != [])
              MyLineChart(
                valueList: dadosLum,
                textFontSize: textFontSize,
                titulo: "Dados da luminosidade:",
                ymin: 0,
                ymax: 1000,
              ),
          ],
        ),
      ),
    );
  }
}

class MyLineChart extends StatelessWidget {
  const MyLineChart({
    super.key,
    required this.valueList,
    required this.textFontSize,
    required this.titulo,
    required this.ymin,
    required this.ymax,
    this.chartSize = 250,
  });

  final List valueList;
  final double textFontSize;
  final String titulo;
  final double ymin;
  final double ymax;
  final double chartSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: textFontSize,
            ),
          ),
        ),
        Container(
          height: chartSize,
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: LineChart(
            LineChartData(
              minY: ymin,
              maxY: ymax,
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: valueList
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(double.parse(entry.key.toString()),
                          double.parse(entry.value.toString())))
                      .toList(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
