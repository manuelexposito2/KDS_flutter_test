import 'dart:async';
import 'package:kds/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket {
  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

}
