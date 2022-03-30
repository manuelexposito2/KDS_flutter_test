part of 'status_order_bloc.dart';

abstract class StatusOrderState extends Equatable {
  const StatusOrderState();

  @override
  List<Object> get props => [];
}

class StatusOrderInitial extends StatusOrderState {}

class StatusOrderLoadingState extends StatusOrderState {}

class StatusOrderSuccessState extends StatusOrderState {
  final OrderDto orderDto;

  const StatusOrderSuccessState(this.orderDto);

  @override
  List<Object> get props => [orderDto];
}

class StatusOrderErrorState extends StatusOrderState {
  final String message;

  const StatusOrderErrorState(this.message);

  @override
  List<Object> get props => [message];
}
