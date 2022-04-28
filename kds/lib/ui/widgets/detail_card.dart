import 'dart:async';

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
  int timesClicked = 0;
  late int clicksToChangeState;
  late StatusDetailRepository statusDetailRepository;
  late StatusOrderRepository statusOrderRepository;
  Color? colorDetailStatus;
  var selectedDetail = "";
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

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
    clicksToChangeState = widget.order.details.length;
    colorDetailStatus = setColorWithStatus(widget.details.demEstado!);
    statusDetailRepository = StatusDetailRepositoryImpl();
    statusOrderRepository = StatusOrderRepositoryImpl();

    //Inicializamos el temporizador si está activado el modo "mostrar ultimo tiempo"

    if (widget.config.mostrarUltimoTiempo!.contains("S")) {
      UserSharedPreferences.getDetailTimer(widget.details.demId.toString())
          .then((value) {
        var timer = value.split(":");

        setState(() {
          hours = int.parse(timer[0]);
          minutes = int.parse(timer[1]);
          seconds = int.parse(timer[2]);
        });
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          seconds = seconds + 1;
        });
        //Seteamos cada segundo
        UserSharedPreferences.setDetailTimer(
            widget.details.demId.toString(), _checkTimerDetail());
      });
    }
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

//Estructura del item
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
            //Si el estado no es T ni está activado mostrar último tiempo, no pasará nada.
            if (widget.details.demEstado != "T" &&
                widget.config.mostrarUltimoTiempo!.contains("S")) {
              setState(() {
                hours = 0;
                minutes = 0;
                seconds = 0;
              });
              UserSharedPreferences.removeDetailTimer(
                  widget.details.demId.toString());
            }
            //Las funciones solo existiran si la comanda no es un mensaje (M) o si la comanda completa está desactivada
            if (!widget.details.demEstado!.contains("M") &&
                !widget.config.comandaCompleta!.contains("N")) {
              DetailDto newStatus = DetailDto(
                  idOrder: order.camId.toString(),
                  idDetail: details.demId.toString(),
                  status: _toggleStateButton(details.demEstado!));

              statusDetailRepository.statusDetail(newStatus).whenComplete(() {
                widget.socket!.emit(WebSocketEvents.modifyDetail, newStatus);
              });
            }
          },
          child: ListTile(
            title: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  details.demTitulo!,
                  style: Styles.textTitle(
                      double.parse(widget.config.letra!) * increaseFont),
                ),
                widget.config.mostrarUltimoTiempo!.contains("S") &&
                        widget.details.demEstado == "T" &&
                        widget.order.camEstado != "T"
                    ? Text(
                        _checkTimerDetail(),
                        style: TextStyle(color: Colors.red),
                      )
                    : Container()
              ],
            ),
            subtitle: details.demSubpro!.isNotEmpty
                ? Row(
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
                  )
                : Container(),
          )),
    );
  }

  //Cambia el estado de los pedidos de la comanda
  String _toggleStateButton(String status) {
    switch (status) {
      case "E":
        return "P";
      case "P":
        if (widget.config.reparto!.contains("S")) {
          return "R";
        } else {
          return "T";
        }

      case "T":
        return "E";

      case "R":
        return "T";

      default:
        return "T";
    }
  }

  _checkTimerDetail() {
    _writeNumber(int value) {
      if (value < 10) {
        return "0$value";
      } else {
        return "$value";
      }
    }

    if (seconds >= 60) {
      setState(() {
        seconds = 0;
        minutes = minutes + 1;
      });

      if (minutes >= 60) {
        setState(() {
          minutes = 0;
          hours = hours + 1;
        });
      }
    }

    return "${_writeNumber(hours)}:${_writeNumber(minutes)}:${_writeNumber(seconds)}";
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

//Setea el color dependiendo del estado de los pedidos de cada comanda

