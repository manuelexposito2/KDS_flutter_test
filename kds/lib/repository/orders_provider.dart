/* import 'dart:convert';

import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/utils/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrdersProvider {
  late final WebSocketChannel _webSocketChannel;
  
  OrderRepository orderRepository = OrderRepositoryImpl();

  OrdersProvider()
      : _webSocketChannel = WebSocketChannel.connect(
            Uri.parse('wss://$apiBaseUrl:$puertoKDS'));

  Stream<LastOrdersResponse> fetchOrders(String filter) {
    return _webSocketChannel.stream.map<LastOrdersResponse>((getLastOrders) =>
        LastOrdersResponse.fromJson(jsonDecode(getLastOrders)));
  }

  void openChannel(String filter) {

    orderRepository
        .getOrders(filter)
        .then((data) => _webSocketChannel.sink.add(data));
  }

  void closeChannel() {
    _webSocketChannel.sink.close();
  }
}
 */