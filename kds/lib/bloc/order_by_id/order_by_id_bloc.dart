import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';

part 'order_by_id_event.dart';
part 'order_by_id_state.dart';

class OrderByIdBloc extends Bloc<OrderByIdEvent, OrderByIdState> {
  final OrderRepository orderRepository;
  OrderByIdBloc(this.orderRepository) : super(OrderByIdInitialState()) {
    on<FetchOrderByIdEvent>(_getOneOrder);
  }

  _getOneOrder(FetchOrderByIdEvent event, Emitter<OrderByIdState> emit) async {
    try {
      final order = await orderRepository.getOrderById(event.id);
      emit(OrderByIdSuccessState(event.id, order));
    } on Exception catch (e) {
      emit(OrderByIdErrorState(e.toString()));
    }
  }
}
