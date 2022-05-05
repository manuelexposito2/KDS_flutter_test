import 'package:kds/models/status/print_order_dto.dart';

abstract class PrintOrderRepository{
  Future<PrintOrderDto> printOrder(PrintOrderDto printOrderDto);

  Future<PrintOrderDto> printAccount(PrintOrderDto printOrderDto);
}