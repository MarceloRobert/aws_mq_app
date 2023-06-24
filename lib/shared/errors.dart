import 'package:flutter/material.dart';

Map<int, String> errorTitles = {
  0: "Erro desconhecido",
  1: "Mensagem mal formatada",
  2: "Sem dados",
  3: "Falha no login",
  4: "Falha no login",
};

// // Exemplo de uso em um scaffold:
// showDialog(
//   context: context,
//   builder: (context) => ErrorAlert(
//     theError: MyErrors.fromJson({"err_id": 2, "err_desc": "teste"}),
//   ),
// );

/// Classe para conter as estruturas e parses de erros do sistema
class MyErrors {
  int errId;
  String errDesc;

  MyErrors(this.errId, this.errDesc);

  /// Parse de json para classe. Json deve ser {'err_id', 'err_desc'}
  MyErrors.fromJson(Map<String, dynamic> theJson)
      : errId = theJson["err_id"],
        errDesc = theJson["err_desc"];

  /// Parse da classe para Json. Saída será {'err_id', 'err_desc'}
  Map<String, dynamic> toJson() => {'err_id': errId, 'err_desc': errDesc};
}

/// Widget para exibir alerta de qualquer erro da classe MyErrors
class ErrorAlert extends StatefulWidget {
  final MyErrors theError;

  const ErrorAlert({super.key, required this.theError});

  @override
  State<ErrorAlert> createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorTitles[widget.theError.errId] ?? errorTitles[0]!),
      content: Text(widget.theError.errDesc),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        )
      ],
    );
  }
}
