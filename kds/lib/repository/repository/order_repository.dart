

import 'dart:async';

import 'package:kds/models/last_orders_response.dart';


abstract class OrderRepository{
  
Future<List<Order>> getOrders(String filter);




}