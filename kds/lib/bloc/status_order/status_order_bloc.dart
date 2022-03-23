import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/repository/status_order_repository.dart';

part 'status_order_event.dart';
part 'status_order_state.dart';

class StatusOrderBloc extends Bloc<StatusOrderEvent, StatusOrderState> {
  final StatusOrderRepository statusOrderRepository;


  StatusOrderBloc(this.statusOrderRepository) : super(StatusOrderInitial()) {
    on<DoStatusOrderEvent>(_doOrderEvent);
  }

  void _doOrderEvent(DoStatusOrderEvent event, Emitter<StatusOrderState> emit)async {
    emit(StatusOrderLoadingState());
    try{
      final statusOrderResponse = await statusOrderRepository.statusOrder(event.orderDto);
      emit(StatusOrderSuccessState());
      return;
    }on Exception catch (e){
      emit(StatusOrderErrorState(e.toString()));
    }
  }
}
