part of 'order_bloc.dart';

abstract class OrdersState extends Equatable{
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState{}

class OrdersFetchError extends OrdersState {
  final String message;
  const OrdersFetchError(this.message);

  @override
  List<Object> get props => [message];
}


class OrdersFetchNoOrders extends OrdersState{
  final String message;
  const OrdersFetchNoOrders(this.message);

  @override 
  List<Object> get props => [message];
}

class OrdersFetchEmpty extends OrdersState{
  final String message;
  const OrdersFetchEmpty(this.message);

  @override 
  List<Object> get props => [message];
}
