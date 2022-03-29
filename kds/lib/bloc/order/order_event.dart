part of 'order_bloc.dart';

abstract class OrdersEvent extends Equatable{
  const OrdersEvent();

  @override 
  List<Object> get props => [];
}

class FetchOrdersWithFilterEvent extends OrdersEvent{
  final String filter;

  const FetchOrdersWithFilterEvent(this.filter);

  @override 
  List<Object> get props => [filter];
}

class FetchOrderByIdEvent extends OrdersEvent{

  final String id;

  const FetchOrderByIdEvent(this.id);

  @override
  List<Object> get props => [id];

}
