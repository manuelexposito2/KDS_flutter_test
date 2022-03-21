
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrdersEvent, OrdersState> {

  final OrderRepository orderRepository;

  OrderBloc(this.orderRepository) : super(OrdersInitial()) {
    on<FetchOrdersWithFilterEvent>(_getOrdersFetched);
  }

  _getOrdersFetched(FetchOrdersWithFilterEvent event, Emitter<OrdersState> emit) async {

    try{
      final orders = await orderRepository.getOrders(event.filter);
      emit(OrdersFetchSuccessState(event.filter, orders));
    } on Exception catch(e){
      debugPrint(e.toString());
      emit(OrdersFetchErrorState(e.toString()));
    }


  }
}
