part of 'status_detail_bloc.dart';

abstract class StatusDetailState extends Equatable {
  const StatusDetailState();
  
  @override
  List<Object> get props => [];
}

class StatusDetailInitial extends StatusDetailState {}

class StatusDetailLoadingState extends StatusDetailState {}

class StatusDetailSuccessState extends StatusDetailState {
  
}

class StatusDetailErrorState extends StatusDetailState {
  final String message;

  const StatusDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}