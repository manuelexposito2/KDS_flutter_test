import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kds/bloc/status_detail/status_detail_bloc.dart';
import 'package:kds/bloc/status_order/status_order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/repository/impl_repo/status_detail_repository_impl.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DetailCard extends StatefulWidget {
  DetailCard(
      {Key? key, required this.details, required this.order, this.socket})
      : super(key: key);
  final Details details;
  final Order order;
  Socket? socket;
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
  

    colorDetailStatus = setColorWithStatus(widget.details.demEstado!);
    return _itemPedido(context, widget.order, widget.details);
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

          
          statusDetailRepository.statusDetail(newStatus).then((value) {
            widget.socket!.emit(
                WebSocketEvents.modifyDetail,
                DetailDto(
                    idOrder: value.idOrder,
                    idDetail: value.idDetail,
                    status: value.status));
          });
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
