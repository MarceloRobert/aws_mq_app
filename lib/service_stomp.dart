import 'package:aws_mq_app/credentials.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompServices {
  static StompClient stompClient = StompClient(
    config: StompConfig(
      url:
          'wss://$endpointAppCredential.amazonaws.com:61619',
      onConnect: onConnectCallback,
      onWebSocketError: onWebSocketErrorCallback,
      onDebugMessage:  onDebugCallback,
      onStompError:  onWebSocketErrorCallback,
      onUnhandledFrame:  onWebSocketErrorCallback,
      onUnhandledMessage:  onWebSocketErrorCallback,
      onUnhandledReceipt:  onWebSocketErrorCallback,
      onDisconnect: onDisonnectCallback,
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

  static void connect() async {
    try {

      stompClient.activate();
    } catch (e) {
      rethrow;
    }
  }

  static void onConnectCallback(StompFrame connectFrame) {
    print('Connected');
    print(connectFrame);
    stompClient.subscribe(
      destination: '/queue/ExampleQueue',
      callback: (message) {
        print(message.body);
      },
      headers: {
        'login': userAppCredential,
        'passcode': passcodeAppCredential
      }
    );
    // stompClient?.send(
    //   destination: '/queue/ExampleQueue',
    //   body: 'Hello, world!',
    // );
    print("Sent");
  }

  static void onDisonnectCallback(StompFrame connectFrame) {
    print('Disconnected');
    print(stompClient);
  }

  static void onWebSocketErrorCallback(dynamic error) {
    print('Error occurred: $error');
  }
  static void onDebugCallback(dynamic error) {
    print('STOMP debug: \n$error');
  }
}
