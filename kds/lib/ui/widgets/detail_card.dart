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
import 'package:kds/ui/widgets/detail_timer.dart';
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

  late StatusDetailRepository statusDetailRepository;
  late StatusOrderRepository statusOrderRepository;
  Color? colorDetailStatus;
  var selectedDetail = "";
  var lastTerminatedDetail = "";

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

    //Inicializamos el temporizador si está activado el modo "mostrar ultimo tiempo"
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
    if (widget.config.soloUltimoPlato!.contains("S")) {
      UserSharedPreferences.getLastDetailSelected().then((value) {
        setState(() {
          lastTerminatedDetail = value;
        });
      });
    }

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

            //Las funciones solo existiran si la comanda no es un mensaje (M) o si la comanda completa está desactivada
            if (!widget.details.demEstado!.contains("M") &&
                !widget.config.comandaCompleta!.contains("N")) {
              DetailDto newStatus = DetailDto(
                  idOrder: order.camId.toString(),
                  idDetail: details.demId.toString(),
                  status: _toggleStateButton(details.demEstado!));

              statusDetailRepository.statusDetail(newStatus).whenComplete(() {
                if (widget.config.soloUltimoPlato != "N" &&
                    newStatus.status == "T") {
                  UserSharedPreferences.removeLastDetailSelected();
                  UserSharedPreferences.setLastDetailSelected(
                      widget.details.demId.toString());
                }

                if (newStatus.status != "T") {
                  UserSharedPreferences.removeDetailTimer(
                      newStatus.idDetail.toString());
                }

                if (details.demEstado == "T") {
                  UserSharedPreferences.removeLastDetailSelected();
                }

                widget.socket!.emit(WebSocketEvents.modifyDetail, newStatus);
              });
            }

            //TODO: GESTIONAR LAS CONDICIONES DE SOLO_ULTIMO_PLATO.
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
                (widget.config.mostrarUltimoTiempo!.contains("S") &&
                                widget.config.soloUltimoPlato!.contains("N") ||
                            (widget.config.soloUltimoPlato!.contains("S") &&
                                lastTerminatedDetail ==
                                    widget.details.demId.toString())) &&
                        widget.details.demEstado == "T" &&
                        widget.order.camEstado != "T"
                    ? DetailTimerWidget(
                        id: widget.details.demId.toString(),
                        status: widget.details.demEstado!,
                        config: widget.config)
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

//Setea el color dependiendo del estado de los pedidos de cada comanda
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
