part of 'status_order_bloc.dart';

abstract class StatusOrderState extends Equatable {
  const StatusOrderState();
  
  @override
  List<Object> get props => [];
}

class StatusOrderInitial extends StatusOrderState {}

class StatusOrderLoadingState extends StatusOrderState {}

class StatusOrderSuccessState extends StatusOrderState {}

class StatusOrderErrorState extends StatusOrderState {
  final String message;

  const StatusOrderErrorState(this.message);

  @override
  List<Object> get props => [message];
}

