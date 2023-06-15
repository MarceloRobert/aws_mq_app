// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import '../app.constant.dart';
// import '../service_stomp.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String? errResult;
//   StompServices socket = StompServices();
//   final StreamController _somaStream = StreamController();
//   final StreamController _mensagemStream = StreamController();
//   final StreamController _arquivoStream = StreamController();
//   final TextEditingController _textEditingController = TextEditingController();

//   bool connected = false;
//   bool listening = false;
//   String topic = "messageInput";

//   @override
//   void initState() {
//     super.initState();
//     // socket.stompClient.activate();
//     connected = true;
//   }

//   @override
//   void dispose() {
//     if (socket.stompClient.connected) {
//       socket.stompClient.deactivate();
//       if (kDebugMode) {
//         print("Disconnected");
//       }
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Amazon MQ app"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "Tópico a ser enviada a mensagem: ",
//               style: h2style,
//             ),
//             DropdownButton(
//               style: selectorStyle,
//               value: topic,
//               items: const [
//                 DropdownMenuItem(value: "functionInput", child: Text("Função")),
//                 DropdownMenuItem(
//                     value: "messageInput", child: Text("Mensagem")),
//                 DropdownMenuItem(value: "fileInput", child: Text("Arquivo")),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   topic = value ?? "messageInput";
//                 });
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Mensagem a ser enviada: ",
//                     style: h2style,
//                   ),
//                   TextField(
//                     style: selectorStyle,
//                     decoration: const InputDecoration(
//                       hintText: 'Escreva a mensagem...',
//                       border: OutlineInputBorder(),
//                     ),
//                     controller: _textEditingController,
//                   ),
//                   //
//                   // Enviar para topico
//                   //
//                   ElevatedButton(
//                     onPressed: () {
//                       try {
//                         socket.sendMessage(_textEditingController.text, topic);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text("Mensagem enviada à $topic")));
//                       } catch (e) {
//                         setState(() {
//                           errResult = e.toString();
//                         });
//                       }
//                     },
//                     child: const Text("Enviar dado"),
//                   ),
//                 ],
//               ),
//             ),
//             //
//             // Dados que foram recebidos
//             //
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Dados recebidos:",
//                     style: h2style,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Soma: ",
//                         style: h3style,
//                       ),
//                       StreamBuilder(
//                         stream: _somaStream.stream,
//                         builder: (context, snapshot) {
//                           return Text(
//                               snapshot.data != null
//                                   ? snapshot.data.toString()
//                                   : "",
//                               style: resultStyle);
//                         },
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Mensagem: ",
//                         style: h3style,
//                       ),
//                       StreamBuilder(
//                         stream: _mensagemStream.stream,
//                         builder: (context, snapshot) {
//                           return Text(
//                               snapshot.data != null
//                                   ? snapshot.data.toString()
//                                   : "",
//                               style: resultStyle);
//                         },
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Arquivo: ",
//                         style: h3style,
//                       ),
//                       StreamBuilder(
//                         stream: _arquivoStream.stream,
//                         builder: (context, snapshot) {
//                           return Text(
//                             snapshot.data != null
//                                 ? snapshot.data.toString()
//                                 : "",
//                             style: resultStyle,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             //
//             Text(
//               errResult != null ? "Último erro:" : "",
//               textAlign: TextAlign.center,
//               style: h2style,
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
//               child: SelectableText(
//                 errResult ?? "",
//                 textAlign: TextAlign.justify,
//               ),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (connected && listening == false) {
//             socket.subscribeToTopic("functionOutput", _somaStream);
//             socket.subscribeToTopic("messageOutput", _mensagemStream);
//             socket.subscribeToTopic("fileOutput", _arquivoStream);
//             setState(() {
//               listening = true;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Ouvindo à todos os tópicos")));
//           } else if (listening == false) {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Não está conectado")));
//           } else {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(const SnackBar(content: Text("Já está ouvindo")));
//           }
//         },
//         child: const Icon(Icons.remove_red_eye),
//       ),
//     );
//   }
// }
