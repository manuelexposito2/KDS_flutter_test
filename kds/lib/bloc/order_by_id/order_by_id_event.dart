part of 'order_by_id_bloc.dart';

abstract class OrderByIdEvent extends Equatable {
  const OrderByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderByIdEvent extends OrderByIdEvent {
  
  final String id;

  const FetchOrderByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
