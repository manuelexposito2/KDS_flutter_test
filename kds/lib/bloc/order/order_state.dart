part of 'order_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersFetchSuccessState extends OrdersState {
  final String filter;
  final List<Order> orders;
  const OrdersFetchSuccessState(this.filter, this.orders);

  @override
  List<Object> get props => [filter];
}

class OrdersFetchErrorState extends OrdersState {
  final String message;
  const OrdersFetchErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class OrdersFetchNoOrdersState extends OrdersState {
  final String message;
  const OrdersFetchNoOrdersState(this.message);

  @override
  List<Object> get props => [message];
}

class OrdersFetchEmptyState extends OrdersState {
  final String message;
  const OrdersFetchEmptyState(this.message);

  @override
  List<Object> get props => [message];
}

class OrderFetchByIdState extends OrdersState {
  final String id;
  final Order order;
  const OrderFetchByIdState (this.id, this.order);

  @override
  List<Object> get props => [id];
}
