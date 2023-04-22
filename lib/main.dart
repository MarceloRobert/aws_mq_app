import 'package:aws_mq_app/service_stomp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.pink, backgroundColor: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? result;
  StompServices socket = StompServices();
  bool connected = true;

  @override
  void initState() {
    super.initState();
    socket.stompClient.activate();
    connected = true;
  }

  @override
  void dispose() {
    if (socket.stompClient.connected) {
      socket.stompClient.deactivate();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Amazon MQ app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                try {
                  socket.test("message", "queue");
                } catch (e) {
                  setState(() {
                    result = e.toString();
                  });
                }
              },
              child: const Text("Enviar dado"),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  socket.subscribeToQueue("queue");
                } catch (e) {
                  setState(() {
                    result = e.toString();
                  });
                }
              },
              child: const Text("Receber dados"),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              result != null ? "Último erro:" : "",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: SelectableText(
                result ?? "",
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          connected
              ? socket.stompClient.deactivate()
              : socket.stompClient.activate();
          setState(() {
            connected = !connected;
          });
        },
        child: connected ? Icon(Icons.power_off) : Icon(Icons.power),
      ),
    );
  }
}
