
import 'package:kds/models/status/order_dto.dart';

abstract class StatusOrderRepository{
  Future<OrderDto> statusOrder(OrderDto orderDto);
}