import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/cambiar_peso_dto.dart';
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
import 'dart:math' as math;

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
  final _formKey = GlobalKey<FormState>();
  TextEditingController pesoController = TextEditingController();

  int timesClicked = 0;

  late StatusDetailRepository statusDetailRepository;
  late StatusOrderRepository statusOrderRepository;
  Color? colorDetailStatus;
  var selectedDetail = "";
  var lastTerminatedDetail = "";
  late final int decimalRange;

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
            if (widget.config.modificarPeso!.contains("S") &&
                details.demPedirPeso == 1 &&
                details.demEstado == "E") {
              //Navigator.of(context).restorablePush(_dialogBuilder);
              _dialogModificarPeso(context);
              //_dialogBuilder
            } else {
              _modifyDetail(order, details);
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
                (widget.config.mostrarUltimoTiempo!.contains("S") &&
                                widget.config.soloUltimoPlato!.contains("N") ||
                            (widget.config.mostrarUltimoTiempo!.contains("S") &&
                                widget.config.soloUltimoPlato!.contains("S") &&
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

  _dialogModificarPeso(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirme peso', style: Styles.textBoldInfo),
            content: _pesoForm(),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                      pesoController.clear();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 70,
                    child: Text(
                      'Cerrar',
                      textAlign: TextAlign.center,
                      style: Styles.textButtonCancelar,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red))),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //CAMBIAR PESO PETICION
                      statusDetailRepository
                          .cambiarPeso(CambiarPesoDto(
                              idOrder: widget.order.camId.toString(),
                              idDetail: widget.details.demId.toString(),
                              pesoAnterior: widget.details.demSubpro!
                                  .replaceAll("Peso: ", "")
                                  .replaceAll("Kg", ""),
                              nuevoPeso: pesoController.text.isEmpty
                                  ? widget.details.demSubpro!
                                      .replaceAll("Peso: ", "")
                                      .replaceAll("Kg", "")
                                  : pesoController.text.replaceAll(",", ".")))
                          .whenComplete(() =>
                              _modifyDetail(widget.order, widget.details));
                      Navigator.of(context).pop();
                      pesoController.clear();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 70,
                    child: Text(
                      'Confirmar',
                      textAlign: TextAlign.center,
                      style: Styles.textButtonCancelar,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)))
            ],
          );
        });
  }

  Widget _pesoForm() {
    var hint = widget.details.demSubpro
        ?.replaceAll("Peso:", "")
        .replaceAll("Kg", "")
        .replaceAll(".", ",");

    return Container(
      height: 600,
      child: Column(
        children: [
          Divider(),
          Container(
              child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 750,
              height: 70,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 54, 54, 54), width: 2)),
              child: TextFormField(
              
                controller: pesoController,
                style: const TextStyle(fontSize: 35),
                decoration: InputDecoration(
                    hintText: hint,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                //keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [],
                enabled: false,
              ),
            ),
          )),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "7";
                  },
                  child: Text("7", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "8";
                  },
                  child: Text("8", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "9";
                  },
                  child: Text("9", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso)
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "4";
                  },
                  child: Text("4", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "5";
                  },
                  child: Text("5", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "6";
                  },
                  child: Text("6", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso)
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "1";
                  },
                  child: Text("1", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "2";
                  },
                  child: Text("2", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "3";
                  },
                  child: Text("3", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso)
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    pesoController.text.contains(",")
                        ? null
                        : pesoController.text = pesoController.text + ",";
                  },
                  child: Text(",", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    pesoController.text.startsWith("0") ||
                            !pesoController.text.contains(",") &&
                                pesoController.text.length >= 6 ||
                            pesoController.text.contains(",") &&
                                pesoController.text.split(",").last.length > 2
                        ? null
                        : pesoController.text = pesoController.text + "0";
                  },
                  child: Text("0", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso),
              ElevatedButton(
                  onPressed: () {
                    pesoController.clear();
                  },
                  child: Text("CE", style: Styles.textPesoBtn),
                  style: Styles.buttonPeso)
            ],
          )
        ],
      ),
    );
  }

  _modifyDetail(Order order, Details details) {
    //Si el estado no es T ni está activado mostrar último tiempo, no pasará nada.

    //Las funciones solo existiran si la comanda no es un mensaje (M) o si la comanda completa está desactivada

    if (!widget.details.demEstado!.contains("M") &&
        !widget.config.comandaCompleta!.contains("N")) {
      DetailDto newStatus = DetailDto(
          idOrder: order.camId.toString(),
          idDetail: details.demId.toString(),
          status: _toggleStateButton(details.demEstado!));

      statusDetailRepository.statusDetail(newStatus).whenComplete(() {
        if (widget.config.mostrarUltimoTiempo!.contains("S")) {
          if (widget.config.soloUltimoPlato != "N" && newStatus.status == "T") {
            UserSharedPreferences.removeLastDetailSelected();
            UserSharedPreferences.setLastDetailSelected(
                widget.details.demId.toString());
          }

          if (newStatus.status == "T") {
            UserSharedPreferences.setDetailTimer(newStatus.idDetail!, 0);
            UserSharedPreferences.removeDetailTimer(
                newStatus.idDetail.toString());
          }
        }

        widget.socket!.emit(WebSocketEvents.modifyDetail, newStatus);
      });
    }
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
