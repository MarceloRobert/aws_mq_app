import 'dart:convert';

import 'package:aws_mq_app/credentials.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompServices {
  StompServices();

  StompClient stompClient = StompClient(
    config: StompConfig(
      url: 'wss://$endpointAppCredential.amazonaws.com:61619',
      onConnect: onConnectCallback,
      onDisconnect: onDisonnectCallback,
      // onDebugMessage: onDebugCallback,
      onWebSocketError: onErrorCallback,
      onStompError: onErrorCallback,
      onUnhandledFrame: onErrorCallback,
      onUnhandledMessage: onErrorCallback,
      onUnhandledReceipt: onErrorCallback,
      stompConnectHeaders: {
        'login': userAppCredential,
        'passcode': passcodeAppCredential
      },
      webSocketConnectHeaders: {
        'login': userAppCredential,
        'passcode': passcodeAppCredential
      },
    ),
  );

  void subscribeToQueue(String queue) {
    print("Subscribing");
    stompClient.subscribe(
      destination: '/queue/$queue',
      callback: (message) {
        print(message.body);
      },
      headers: {
        'login': userAppCredential,
        'passcode': passcodeAppCredential,
      },
    );
  }

  void unsubscribeFromQueue(String queue) {
    print("Unsubscribing");
    // TODO: implement
  }

  void test(String message, String queue) {
    print("Sending");
    stompClient.send(
      destination: '/queue/$queue',
      body: json.encode({"message": message}),
    );
  }

  static void onConnectCallback(StompFrame connectFrame) {
    print('Connected');
  }

  static void onDisonnectCallback(StompFrame connectFrame) {
    print('Disconnected');
  }

  static void onErrorCallback(dynamic error) {
    print('Error occurred: $error');
  }

  static void onDebugCallback(dynamic error) {
    print('STOMP debug: \n$error');
  }
}
