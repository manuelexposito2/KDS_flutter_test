part of 'order_by_id_bloc.dart';

abstract class OrderByIdState extends Equatable {
  const OrderByIdState();

  @override
  List<Object> get props => [];
}

class OrderByIdInitialState extends OrderByIdState {}

class OrderByIdErrorState extends OrderByIdState {
  final String message;
  const OrderByIdErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class OrderByIdLoadingState extends OrderByIdState {}

class OrderByIdSuccessState extends OrderByIdState {
  final String id;
  final Order order;

  const OrderByIdSuccessState(this.id, this.order);

  @override
  List<Object> get props => [id];
}
