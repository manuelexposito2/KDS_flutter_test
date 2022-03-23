part of 'status_order_bloc.dart';

abstract class StatusOrderEvent extends Equatable {
  const StatusOrderEvent();

  @override
  List<Object> get props => [];
}

class DoStatusOrderEvent extends StatusOrderEvent{
  final OrderDto orderDto;

  const DoStatusOrderEvent(this.orderDto);
}
