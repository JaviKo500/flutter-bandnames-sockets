
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}
class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;
  
  ServerStatus get serverStatus => _serverStatus;

  late IO.Socket _socket;
  
  IO.Socket get socket => _socket;
  get emit => _socket.emit;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    _socket = IO.io(
      'http://192.168.1.2:3000', 
      IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .enableAutoConnect() 
        .build()
    );
    _socket.on('connect', ( _ ) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.on('disconnect', (data) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    _socket.on('new-message', (payload) {
      print('messge:');
      print('name: ${payload['name']}');
      print('message: ${payload['message']}');
      print(payload.containsKey('message2') ? 'existe' : 'no existe' );
    });
  }
}