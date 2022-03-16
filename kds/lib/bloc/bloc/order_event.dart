part of 'order_bloc.dart';

abstract class OrdersEvent extends Equatable{
  const OrdersEvent();

  @override 
  List<Object> get props => [];
}

class FetchOrdersWithType extends OrdersEvent{
  final String type;

  const FetchOrdersWithType(this.type);

  @override 
  List<Object> get props => [type];
}
