import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:sparkd/core/constants/imports.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  final String serverUrl = Constants.socketBaseUrl; 

  @override
  Future<void> onInit() async {
    super.onInit();
    print("iam hete");
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(serverUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .enableReconnection() 
        .setReconnectionAttempts(5)
        .setReconnectionDelay(2000) 
        .build());
    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    socket.onReconnect((_) {
      print('Reconnecting...');
    });

    socket.onReconnectError((error) {
      print('Reconnect error: $error');
    });

    socket.onReconnectFailed((_) {
      print('Reconnect failed after maximum attempts');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }

  void listenToEvent(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void closeConnection() {
    socket.disconnect();
  }
}
