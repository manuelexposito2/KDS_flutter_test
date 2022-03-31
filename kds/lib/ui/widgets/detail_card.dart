import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kds/bloc/status_detail/status_detail_bloc.dart';
import 'package:kds/bloc/status_order/status_order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/repository/impl_repo/status_detail_repository_impl.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/ui/styles/styles.dart';

class DetailCard extends StatefulWidget {
  DetailCard({Key? key, required this.details, required this.order})
      : super(key: key);
  final Details details;
  final Order order;

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  late StatusDetailRepository statusDetailRepository;
  Color? colorDetailStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    colorDetailStatus = setColorWithStatus(widget.details.demEstado!);
    statusDetailRepository = StatusDetailRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusDetailBloc(statusDetailRepository),
      child: _blocItemPedidoBuilder(context, widget.order, widget.details),
    );
  }

  Widget _blocItemPedidoBuilder(
      BuildContext context, Order order, Details details) {
    return BlocConsumer<StatusDetailBloc, StatusDetailState>(
        builder: ((context, state) {
      if (state is StatusDetailSuccessState) {
        colorDetailStatus = setColorWithStatus(state.detailDto.status!);
        return _itemPedido(context, order, details);
      } else {
        return _itemPedido(context, order, details);
      }
    }), buildWhen: ((context, state) {
      return state is StatusDetailInitial ||
          state is StatusDetailSuccessState ||
          state is StatusDetailLoadingState;
    }), listenWhen: ((context, state) {
      return state is StatusDetailSuccessState ||
          state is StatusDetailInitial ||
          state is StatusDetailErrorState;
    }), listener: ((context, state) {
      if (state is StatusDetailSuccessState) {
        setState(() {
          colorDetailStatus = setColorWithStatus(state.detailDto.status!);
        });
      }
    }));
  }

  Widget _itemPedido(BuildContext context, Order order, Details details) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorDetailStatus,
          primary: Color.fromARGB(255, 87, 87, 87),
        ),
        onPressed: () {
          
          DetailDto newStatus = DetailDto(
              idOrder: order.camId.toString(),
              idDetail: details.demId.toString(),
              status: _toogleStateButton(details.demEstado!));

          BlocProvider.of<StatusDetailBloc>(context)
              .add(DoStatusDetailEvent(newStatus));
        },
        child: ListTile(
          title: Text(
            details.demTitulo!,
            style: Styles.textTitle,
          ),
        ),
      ),
    );
  }

  String _toogleStateButton(String status) {
    if (status.contains('E')) {
      return 'P';
    } else if (status.contains('P')) {
      return 'T';
    } else {
      return 'E';
    }
  }

  setColorWithStatus(String status) {
    switch (status) {
      case "E":
        return Colors.white;

      case "P":
        return Color(0xFFF5CB8F);

      case "T":
        return Color(0xFFB0E1A0);

      default:
        return Colors.white;
    }
  }
}
