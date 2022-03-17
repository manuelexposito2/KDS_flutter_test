

import 'package:kds/models/last_orders_response.dart';
import 'package:kds/utils/constants.dart';

abstract class OrderRepository{
  
Future<List<Order>> getOrders(String filter);




}