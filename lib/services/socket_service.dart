import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hittapa/global.dart';

class SocketService {
  IO.Socket socket;

  createSocketConnection() {
    socket = IO.io(BASE_SOCKET_ENDPOINT, <String, dynamic>{
      'transports': ['websocket'],
    });

    this.socket.on("connect", (_) => print('--------------- Connected ------------------'));
    this.socket.on("disconnect", (_) => print('*************** Disconnected *****************'));
  }
}