

import 'package:kds/models/last_orders_response.dart';
import 'package:kds/utils/constants.dart';

abstract class ComandaRepository{
  
Future<List<Order>> getOrders(String filter);




}