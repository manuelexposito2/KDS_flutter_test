part of 'status_detail_bloc.dart';

abstract class StatusDetailEvent extends Equatable {
  const StatusDetailEvent();

  @override
  List<Object> get props => [];
}

class DoStatusDetailEvent extends StatusDetailEvent{
  final DetailDto detailDto;

  const DoStatusDetailEvent(this.detailDto);
}
