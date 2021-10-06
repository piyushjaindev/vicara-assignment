import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';

class WebSocket {
  late Socket _socket;
  final _socketResponse = StreamController<String>();

  WebSocket() {
    _socket = io(
        'https://vicars-assignment.herokuapp.com/',
        OptionBuilder()
            .setExtraHeaders({'Content-Type': 'application/json'})
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    _socket.connect();
    _socket.onConnect((data) => print('connected'));
    _socket.onConnectTimeout((data) => print(data));
    _socket.onConnectError((data) => print(data));
    _socket.on('response', (data) => addResponse(data));
  }

  void addResponse(var event) {
    _socketResponse.sink.add(event);
  }

  Stream<String> get getSocketEvents => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
    _socket.disconnect();
  }

  void addSocketEvent(String eventName, Map data) {
    _socket.emit(eventName, jsonEncode(data));
  }
}
