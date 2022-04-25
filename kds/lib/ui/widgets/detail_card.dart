import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/impl_repo/status_detail_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/user_shared_preferences.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';

class DetailCard extends StatefulWidget {
  DetailCard(
      {Key? key,
      required this.details,
      required this.order,
      this.socket,
      required this.config})
      : super(key: key);
  final Details details;
  final Order order;
  Config config;
  Socket? socket;
  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  late StatusDetailRepository statusDetailRepository;
  late StatusOrderRepository statusOrderRepository;
  Color? colorDetailStatus;
  var selectedDetail = "";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    colorDetailStatus = setColorWithStatus(widget.details.demEstado!);
    statusDetailRepository = StatusDetailRepositoryImpl();
    statusOrderRepository = StatusOrderRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {
    colorDetailStatus = widget.config.comandaCompleta!.contains("S")
        ? setColorWithStatus(widget.details.demEstado!)
        : Colors.white;
    return widget.details.demArti != demArticuloSeparador
        ? _itemPedido(context, widget.order, widget.details)
        : Styles.separadorComanda;
  }

  Widget _itemPedido(BuildContext context, Order order, Details details) {
    //Setea el selectedDetail para ver si debe pintar este Detail o no
    UserSharedPreferences.getResumeCall().then(((value) {
      setState(() {
        selectedDetail = value;
      });
    }));

    return Container(
      margin: EdgeInsets.only(left: 2, right: 2, bottom: 1),
      child: TextButton(
          style: TextButton.styleFrom(
            side: details.demTitulo!.split(" X ").last == selectedDetail &&
                    details.demEstado != "T" &&
                    details.demArti != demArticuloSeparador
                ? BorderSide(color: Colors.red, width: 5.0)
                : BorderSide.none,
            backgroundColor: colorDetailStatus,
            primary: Color.fromARGB(255, 87, 87, 87),
          ),
          onPressed: () {
            //Las funciones solo existiran si la comanda no es un mensaje (M) o si la comanda completa está desactivada
            if (!widget.details.demEstado!.contains("M") &&
                !widget.config.comandaCompleta!.contains("N")) {
              DetailDto newStatus = DetailDto(
                  idOrder: order.camId.toString(),
                  idDetail: details.demId.toString(),
                  status: _toogleStateButton(details.demEstado!));
              OrderDto newOrderStatus = OrderDto(
                  idOrder: order.camId.toString(),
                  status: _toogleStateButton(order.camEstado.toString()));

              statusDetailRepository.statusDetail(newStatus).whenComplete(() {
                widget.socket!.emit(WebSocketEvents.modifyDetail, newStatus);
                
              });
            } 
          },
          child: details.demSubpro!.isNotEmpty
              ? ListTile(
                  title: Text(
                    details.demTitulo!,
                    style: Styles.textTitle(
                        double.parse(widget.config.letra!) * increaseFont),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.arrow_right,
                          size: double.parse(widget.config.letra!) *
                              increaseFont),
                      Text(
                        details.demSubpro.toString(),
                        style: Styles.subTextTitle(
                            double.parse(widget.config.letra!) * increaseFont),
                      )
                    ],
                  ))
              : ListTile(
                  title: Text(
                    details.demTitulo!,
                    style: Styles.textTitle(
                        double.parse(widget.config.letra!) * increaseFont),
                  ),
                )),
    );
  }

  String _toogleStateButton(String status) {
    if (status.contains('E')) {
      return 'P';
    } else if (widget.config.reparto == "S" && status.contains('P')) {
      return 'R';
    } else if (widget.config.reparto == "N" && status.contains('P') ||
        status.contains('R')) {
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

      case "R":
        return Color.fromARGB(255, 211, 161, 219);

      default:
        return Colors.white;
    }
  }
}
