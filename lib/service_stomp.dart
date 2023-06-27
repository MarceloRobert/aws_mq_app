import 'dart:async';
import 'dart:convert';

import 'package:hidroponia/credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StompServices {
  StompServices();

  static Completer isConnected = Completer();

  StompClient stompClient = StompClient(
    config: StompConfig(
      url: urlAppCredential,
      onConnect: onConnectCallback,
      onDisconnect: onDisonnectCallback,
      // onDebugMessage: onDebugCallback,
      onWebSocketError: onWebSocketErrorCallback,
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
    } else {
      isConnected.complete();
    }
    return isConnected.future;
  }

  /// Se inscreve no tópico dado, os dados serão repassados para a stream.
  /// Tópico como "nome" ou "nome/subtopico/..."
  StompUnsubscribe subscribeToTopic(String topic, StreamController theStream) {
    if (kDebugMode) {
      print("Subscribing to $topic");
    }
    return stompClient.subscribe(
      destination: '/topic/$topic',
      callback: (message) {
        String decodedMessage = utf8.decoder.convert(message.binaryBody!);
        if (kDebugMode) {
          print("Received Message in topic $topic:\n$decodedMessage");
        }
        // Se a resposta do servidor vier no formato de erro, adiciona erro
        try {
          if (jsonDecode(decodedMessage)["err_id"] != null) {
            theStream.addError(decodedMessage);
          } else {
            theStream.add(decodedMessage);
          }
        } catch (e) {
          theStream
              .add(decodedMessage); // no caso do alerta, virá apenas uma string
        }
      },
    );
  }

  /// Envia mensagem para o tópico.
  /// Mensagem deve ser String.
  /// Tópico como "nome" ou "nome/subtopico/..."
  void sendMessage(String message, String topic) {
    if (kDebugMode) {
      print("Sending to $topic");
    }
    stompClient.send(
      destination: '/topic/$topic',
      body: message,
    );
  }

  //
  // Callbacks
  //

  static void onConnectCallback(StompFrame connectFrame) {
    if (kDebugMode) {
      print('Connected');
    }
    if (connectFrame.body == null) {
      if (isConnected.isCompleted == false) {
        isConnected.complete("connected");
      }
    }
  }

  static void onDisonnectCallback(StompFrame connectFrame) {
    if (kDebugMode) {
      print('Disconnected');
    }
  }

  static void onDebugCallback(dynamic debugMessage) {
    if (kDebugMode) {
      print('STOMP debug: \n$debugMessage');
    }
  }

  //
  // Error callbacks
  //

  static void onWebSocketErrorCallback(dynamic error) {
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
}
