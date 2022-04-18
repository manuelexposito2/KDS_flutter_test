import 'dart:async';

import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/config.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders(String filter, Config config);

  Future<Order> getOrderById(String id, Config config);
}
