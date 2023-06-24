import 'dart:async';
import 'dart:convert';

import 'package:aws_mq_app/credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompServices {
  StompServices();

  static Completer isConnected = Completer();

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
    ),
  );

  Future makeConnection() async {
    if (isConnected.isCompleted == true) {
      isConnected = Completer();
    }
    stompClient.activate();
    return isConnected.future;
  }

  revokeConnection() async {
    if (isConnected.isCompleted == true) {
      isConnected = Completer();
    }
    stompClient.deactivate();
  }

  Future connectDebug() {
    if (isConnected.isCompleted == true) {
      isConnected = Completer();
    }
    isConnected.complete();
    return isConnected.future;
  }

  void subscribeToTopic(String topic, StreamController theStream) {
    if (kDebugMode) {
      print("Subscribing to $topic");
    }
    stompClient.subscribe(
      destination: '/topic/$topic',
      callback: (message) {
        String decodedMessage = utf8.decoder.convert(message.binaryBody!);
        if (kDebugMode) {
          print("Received Message in topic $topic:\n$decodedMessage");
        }
        theStream.add(decodedMessage);
      },
    );
  }

  void sendMessage(String message, String topic) {
    if (kDebugMode) {
      print("Sending to $topic");
    }
    stompClient.send(
      destination: '/topic/$topic',
      body: message,
    );
  }

  static void onConnectCallback(StompFrame connectFrame) {
    if (kDebugMode) {
      print('Connected');
    }
    if (connectFrame.body == null) {
      isConnected.complete("connected");
    }
  }

  static void onDisonnectCallback(StompFrame connectFrame) {
    if (kDebugMode) {
      print('Disconnected');
    }
  }

  static void onErrorCallback(dynamic error) {
    if (error is WebSocketChannelException) {
      if (kDebugMode) {
        print('Error occurred: ${error.message}');
      }
      if (isConnected.isCompleted == false) {
        isConnected.completeError(error.message!.split(":")[1]);
      }
    } else {
      isConnected.completeError("Erro desconhecido");
    }
  }

  static void onDebugCallback(dynamic debugMessage) {
    if (kDebugMode) {
      print('STOMP debug: \n$debugMessage');
    }
  }
}
