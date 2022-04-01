import 'dart:async';
import 'package:kds/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    Socket socket = io(
        'http://$apiBaseUrl:$puertoKDS',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.onConnect((_) {
      print("Connected");
    });
    //socket.emit('newOrder', 'testhola');
    //When an event recieved from server, data is added to the stream
    socket.on('newOrder', (data) => print("$data"));
    // socket.on('newOrder', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }
}
