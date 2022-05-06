import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kds/models/get_workers_response.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/models/status/read_options_dto.dart';
import 'package:kds/models/status/urgente_dto.dart';
import 'package:kds/repository/impl_repo/options_repository_impl.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/impl_repo/urgent_repository_impl.dart';
import 'package:kds/repository/impl_repo/workers_repository_impl.dart';
import 'package:kds/repository/repository/options_repository.dart';

import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/repository/repository/urgent_repository.dart';
import 'package:kds/repository/repository/workers_repository.dart';
import 'package:kds/ui/styles/custom_icons.dart';

import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/detail_card.dart';
import 'package:kds/ui/widgets/labeled_checkbox.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:convert' show utf8;

class OrderCard extends StatefulWidget {
  OrderCard({Key? key, required this.order, this.socket, required this.config})
      : super(key: key);

  Socket? socket;
  Config config;
  final Order? order;

  @override
  State<OrderCard> createState() => _ComandaCardState();
}

class _ComandaCardState extends State<OrderCard> {
  late OptionsRepository optionsRepository;
  late StatusOrderRepository statusOrderRepository;
  late UrgenteRepository urgenteRepository;
  late Future<ReadOptionsDto?> futureOptions;

  Order? order;

  late OrderRepository orderRepository;
  late WorkersRepository workersRepository;
  //Esta comanda es la misma que la principal pero existe para darle más datos
  Future<Order>? orderExtended;
  Future<List<GetWorkers>>? listaOperarios;
  Color? colorOrderStatus;
  Color? color;
  OrderDto? status;
  String? _timeString;

  ReadOptionsDto? currentOptions;

  int opcion1 = 0;
  int opcion2 = 0;
  int opcion3 = 0;
  int opcion4 = 0;
  int opcion5 = 0;
  int opcion6 = 0;
  int opcion7 = 0;
  int opcion8 = 0;

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
    optionsRepository = OptionsRepositoryImpl();
    workersRepository = WorkersRepositoryImpl();
    urgenteRepository = UrgentRepositoryImpl();
    orderRepository = OrderRepositoryImpl();
    statusOrderRepository = StatusOrderRepositoryImpl();

//    optionsRepository.readOpciones(widget.order!.camId.toString()).then((value) => currentOptions = value);
  }

  @override
  Widget build(BuildContext context) {
    futureOptions = optionsRepository
        .readOpciones(widget.order!.camId.toString())
        .then((value) => currentOptions = value);

    _checkAllDetails(widget.order!.camEstado!);

    if (widget.order!.camEstado == "E" &&
        widget.order!.details
            .where((element) => element.demEstado != "E")
            .isNotEmpty) {
      colorOrderStatus = Styles.mediumColor;
    } else {
      colorOrderStatus = setColor(widget.order!.camEstado!);
    }
    //Imprime la comanda mostrando una animación
    return ShowUpAnimation(
        delayStart: Duration(milliseconds: 200),
        animationDuration: Duration(milliseconds: 350),
        curve: Curves.bounceIn,
        direction: Direction.vertical,
        offset: 0.5,
        child: Container(
          decoration: BoxDecoration(
              color: colorOrderStatus,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          margin: EdgeInsets.all(10),
          width: 300,
          child: _contentCard(context, widget.order!),
        ));
  }

  //Dependiendo del estado del item imprimirá un color u otro
  setColor(String status) {
    if (status == "E") {
      return Styles.baseColor;
    }
    if (status == "P") {
      return Styles.mediumColor;
    }
    if (status == "T") {
      return Styles.succesColor;
    }
    if (status == "R") {
      return Styles.purpleBtn;
    }
    if (status == "M") {
      return Styles.incidenciaColor;
    }
  }

  //Si se pulsó el botón de urgente se imprimirá este item dentro de la comanda
  Widget _showUrgente(BuildContext context, Order order) {
    if (widget.order!.camUrgente.toString() == "1") {
      return _urgente(context);
    } else {
      return Container();
    }
  }

  //Contenido de la comanda
  Widget _contentCard(BuildContext context, Order order) {
    return Column(
      children: [
        _comandaHeader(context, order),
        _showUrgente(context, order),
        _comandaLineas(context, order)
      ],
    );
  }

  //Pinta la cabecera de las comandas
  Widget _comandaHeader(BuildContext context, Order order) {
    //Actualiza el tiempo cada minuto del método total()
    Timer.periodic(
      Duration(minutes: 1),
      (Timer t) => setState(() {
        total(order);
      }),
    );
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  total(order) + ' min.',
                  style: Styles.regularText,
                ),
              ),
              widget.order!.camComensales! >= 1
                  ? Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          Text(
                            order.camComensales.toString(),
                            style: Styles.regularText,
                          )
                        ],
                      ),
                    )
                  : Container(),
              widget.order!.camEstado != "M"
                  ? Container(
                      child: Text(
                        //CONTADOR LINEAS ---> Si estan terminadas o en preparandose
                        '${order.details.where((element) => element.demArti != demArticuloSeparador && (element.demEstado!.contains('R') || element.demEstado!.contains('T') || element.demEstado!.contains('P'))).toList().length}/${order.details.where((element) => element.demArti != demArticuloSeparador).toList().length}',
                        style: Styles.regularText,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        widget.config.muestraOperario!.contains("S")
            ? Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    Text(
                      order.camOperario!,
                      style: Styles.regularText,
                    )
                  ],
                ),
              )
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.push_pin,
                    color: Colors.white,
                  ),
                  Text(
                    order.camMesa.toString(),
                    style: Styles.regularText,
                  )
                ],
              ),
              widget.order!.camEstado != "M"
                  ? Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      width: 40,
                      height: 40,
                      child: IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                orderExtended = orderRepository.getOrderById(
                                    widget.order!.camId.toString(),
                                    widget.config);

                                return AlertDialog(
                                  content: _futureInfo(context),
                                );
                              },
                              barrierDismissible: true),
                          icon: Icon(
                            Icons.info,
                            color: Color.fromARGB(255, 87, 87, 87),
                          )))
                  : Container(),
            ],
          ),
        ),
        widget.config.reparto!.contains("S") &&
                widget.config.opciones.isNotEmpty &&
                order.camEstado!.contains('R')
            ? Container(
                height: 50,
                color: Colors.white,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Flexible(flex: 1, child: optionsFutureImageList(context))
                  ]),
                ),
              )
            : Container(),
        //readOpciones(),
        //optionsFutureImageList(context),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          color: Colors.grey.shade400,
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: SizedBox(
                      width: 195,
                      height: 50,
                      child: SizedBox(
                          width: 195,
                          height: 50,
                          child: !order.camEstado!.contains('R')
                              ? _buttonStates(order)
                              : _buttonAsignar(order)),
                    ),
                  )),
              widget.order!.camEstado != "M"
                  ? Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 95,
                        height: 50,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              primary: Color.fromARGB(255, 87, 87, 87)),
                          child: Icon(Icons.print),
                          onPressed: () {},
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget optionsFutureImageList(BuildContext context) {
    return FutureBuilder<ReadOptionsDto?>(
        future: futureOptions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return optionsImageList(snapshot.data!);
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });
  }

  Widget optionsImageList(ReadOptionsDto readOptionsDto) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 40,
          mainAxisExtent: 50,
          crossAxisCount: 8,
        ),
        shrinkWrap: true,
        itemCount: widget.config.opciones.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //Ignoramos el primer index ya que es el id
          //widget.order!.camId.toString()
          index = index + 1;
          if (index > 8) {
            return Container();
          }
          return IconButton(
              iconSize: 40,
              splashRadius: 0.1,
              onPressed: () {
                _getOptionValue(readOptionsDto, index - 1) == 1
                    ? setState(() {
                        //1
                      })
                    : setState(() {
                        //0
                      });

                print(index);
              },
              icon: _getOptionValue(readOptionsDto, index - 1) >= 1
                  ? Image.asset(
                      'assets/images/${index.toString()}.png',
                      width: 40,
                    )
                  : Image.asset('assets/images/${index.toString()}0.png',
                      width: 40));
        });
  }

  //Ve todos los detalles de la comanda y la setea en el estado correspondiente
  _checkAllDetails(String status) {
    //TODO: Optimizar este código

    String newStatus = _toggleStateButton(status);
    String nextStatus = _toggleStateButton(newStatus);
    String lastStatus = _toggleStateButton(nextStatus);

    if (widget.order!.details
            .where((element) =>
                element.demEstado == newStatus &&
                element.demArti != demArticuloSeparador)
            .length ==
        widget.order!.details
            .where((element) => element.demArti != demArticuloSeparador)
            .length) {
      OrderDto newOrderStatus =
          OrderDto(idOrder: widget.order!.camId.toString(), status: newStatus);

      statusOrderRepository.statusOrder(newOrderStatus).whenComplete(() =>
          widget.socket!.emit(WebSocketEvents.modifyOrder, newOrderStatus));
    } else if (widget.order!.details
            .where((element) =>
                element.demEstado == nextStatus &&
                element.demArti != demArticuloSeparador)
            .length ==
        widget.order!.details
            .where((element) => element.demArti != demArticuloSeparador)
            .length) {
      OrderDto newOrderStatus =
          OrderDto(idOrder: widget.order!.camId.toString(), status: nextStatus);

      statusOrderRepository.statusOrder(newOrderStatus).whenComplete(() =>
          widget.socket!.emit(WebSocketEvents.modifyOrder, newOrderStatus));
    } else if (widget.config.reparto!.contains("S") &&
        widget.order!.details
                .where((element) =>
                    element.demEstado == lastStatus &&
                    element.demArti != demArticuloSeparador)
                .length ==
            widget.order!.details
                .where((element) => element.demArti != demArticuloSeparador)
                .length) {
      OrderDto newOrderStatus =
          OrderDto(idOrder: widget.order!.camId.toString(), status: lastStatus);

      statusOrderRepository.statusOrder(newOrderStatus).whenComplete(() =>
          widget.socket!.emit(WebSocketEvents.modifyOrder, newOrderStatus));
    }
  }

  //Dependiendo del estado de la orden cambiará el aspecto del botón
  Widget _buttonStates(Order order) {
    Text label = const Text('Preparar');
    Icon icon = const Icon(
      Icons.play_arrow,
      color: Color(0xFF337AB7),
      size: 30,
    );

    String status = _toggleStateButton(order.camEstado!);

    if (order.camEstado == 'T') {
      label = const Text('Recuperar');
      icon = const Icon(
        Icons.replay_outlined,
        color: Color.fromARGB(255, 61, 61, 61),
        size: 30,
      );
    } else if (order.camEstado == 'P') {
      label = const Text('Terminar');
      icon = const Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 19, 165, 19),
        size: 30,
      );
    } else if (order.camEstado == 'M') {
      label = const Text("Eliminar");
      icon = Icon(Icons.close, color: Styles.incidenciaColor);
      status = "T";
    }
    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: Color.fromARGB(255, 87, 87, 87),
          textStyle: TextStyle(fontSize: 18)),
      onPressed: () {
        OrderDto newStatus =
            OrderDto(idOrder: order.camId.toString(), status: status);

        statusOrderRepository.statusOrder(newStatus).whenComplete(() {
          widget.socket!.emit(WebSocketEvents.modifyOrder, newStatus);
        });

        ////debugPrint(newStatus.idOrder);
        ////debugPrint(newStatus.status);
      },
      icon: icon,
      label: label,
    );
  }

  //Botón para poder asignar repartidor
  Widget _buttonAsignar(Order order) {
    var bgColor = Colors.white;
    var primaryColor = Color.fromARGB(255, 87, 87, 87);
    var txtStyle = TextStyle(fontSize: 18);

    if (widget.config.seleccionarOperario!.contains("S")) {
      return TextButton.icon(
        style: TextButton.styleFrom(
            backgroundColor: bgColor,
            primary: primaryColor,
            textStyle: txtStyle),
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              listaOperarios = workersRepository.getWorkers(widget.config);
              return AlertDialog(
                content: _futureWorkers(context),
              );
            },
            barrierDismissible: true),
        icon: Icon(Icons.check_box),
        label: const Text("Asignar"),
      );
    } else {
      return TextButton.icon(
        style: TextButton.styleFrom(
            backgroundColor: bgColor,
            primary: primaryColor,
            textStyle: txtStyle),
        onPressed: () {
          OrderDto newStatus =
              OrderDto(idOrder: order.camId.toString(), status: "T");

          statusOrderRepository.statusOrder(newStatus).then((value) {
            widget.socket!.emit(WebSocketEvents.modifyOrder,
                OrderDto(idOrder: value.idOrder, status: value.status));
          });
        },
        icon: Icon(Icons.check_box),
        label: const Text("Entregar"),
      );
    }
  }

  //Trae a los trabajadores para poder seleccionarlos
  Widget _futureWorkers(BuildContext context) {
    return FutureBuilder(
      future: listaOperarios,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _dialogAsignarParaPedido(
              context, snapshot.data as List<GetWorkers>);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  //Muestra lista de operarios para "Reparto"
  Widget _dialogAsignarParaPedido(
      BuildContext context, List<GetWorkers> operarios) {
    return SizedBox(
      height: 220,
      width: 800,
      child: Column(
        children: [
          const Align(
              alignment: Alignment.topLeft, child: Text("Seleccione operario")),
          Divider(thickness: 3.0),
          SizedBox(
            width: 800,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: operarios.length,
                itemBuilder: (context, index) {
                  return _setDealerCard(operarios.elementAt(index));
                }),
          ),
          Divider(thickness: 3.0),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomIcons.closeBlueBtn(context),
          )
        ],
      ),
    );
  }

  //Muestra cada operario y lo setea
  Widget _setDealerCard(GetWorkers worker) {
    return Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: Colors.grey)),
        child: InkWell(
          onTap: () {
            workersRepository
                .setDealer(widget.config, widget.order!.camId.toString(),
                    worker.oprCodigo)
                .then((value) {
              // print(value.setDealer.status);

              if (value.setDealer.status == "OK") {
                OrderDto newStatus = OrderDto(
                    idOrder: widget.order!.camId.toString(), status: "T");

                statusOrderRepository.statusOrder(newStatus).then((value) =>
                    widget.socket!
                        .emit(WebSocketEvents.modifyOrder, newStatus));
              } else {
                //TODO: Gestionar alerta

              }
            }).whenComplete(() => Navigator.pop(context));
          },
          child: SizedBox(
              width: 200, child: Center(child: Text(worker.oprNombre))),
        ));
  }

  //
  Widget _futureInfo(BuildContext context) {
    return FutureBuilder<Order>(
      future: orderExtended,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return information(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _comandaLineas(BuildContext context, Order order) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        for (var d in order.details)
          DetailCard(
            details: d,
            order: order,
            socket: widget.socket,
            config: widget.config,
            key: ValueKey(d.demId),
          )
      ],
    );
  }

  Widget _urgente(BuildContext context) {
    //Si cam_urgente == 1 mostrar widget, si no ocultarlo.
    //Setear el 1 al valor al darle click al botón Urgente dentro del Widget de information
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Styles.alertColor,
      alignment: Alignment.center,
      height: 65,
      //Hacer condición de que solo sale este espacio si se da tap en el botón de urgente
      child: Text(
        '¡¡¡URGENTE!!!',
        style: Styles.urgent(double.parse(widget.config.letra!) * increaseFont),
      ),
    );
  }

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

  //Transforma el tiempo de alta de la orden de Datetime a minutos
  String total(Order order) {
    var date = DateTime.fromMillisecondsSinceEpoch(order.camFecini! * 1000);
    var date2 = DateTime.now();
    final horatotal = date2.difference(date);
    return horatotal.inMinutes.toString();
  }

  //Dependiendo de la inicial dada pinta el "estado" dentro del diálogo de información
  camEstado(Order order) {
    if (order.camEstado == 'E') {
      return 'En espera';
    } else if (order.camEstado == 'P') {
      return 'En proceso';
    } else if (order.camEstado == 'R') {
      return 'En recogida';
    } else if (order.camEstado == 'T') {
      return 'Terminado';
    }
  }

  //Pinta el estado del cobro pintará el ícono correspondiente dentro del diálogo de información
  esPagado(Order order) {
    if (order.camEstadoCab == 'C') {
      return Row(
        children: [
          Icon(Icons.euro_outlined),
          Text(' Pagado: ', style: Styles.textBoldInfo),
          const Icon(
            Icons.check,
            color: Colors.green,
            size: 40,
          ),
          Text('SI', style: Styles.textRegularInfo)
        ],
      );
    } else if (order.camEstadoCab == 'P') {
      return Row(
        children: [
          Icon(Icons.euro_outlined),
          Text(' Pagado: ', style: Styles.textBoldInfo),
          /* */ Icon(
            Icons.cancel_sharp,
            color: Colors.red,
            size: 40,
          ),
          Text('NO', style: Styles.textRegularInfo)
        ],
      );
    }
  }

  //Diálogo que se muestra al pulsar el botón de información
  Widget information(BuildContext context, Order order) {
    var espaciado = EdgeInsets.only(bottom: 20);

    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Text(
                    'Información de comanda',
                    style: Styles.textTitleInfo,
                  ),
                ),
                const Divider(),
                Wrap(
                  children: [
                    Container(
                      width: 400,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Text(
                              'General',
                              style: Styles.textTitleInfo,
                            ),
                          ),
                          //TODO: Comprobar como se ven algunos de estos datos: Nombre de cliente, agencia... etc
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Styles.infoTitle(
                                  const Icon(Icons.person),
                                  ' Cliente: ',
                                  '${order.cliNombre} ${order.cliApellidos}'),
                              Styles.infoTitle(
                                  const Icon(Icons.business_outlined),
                                  ' Agencia: ',
                                  order.agcNombre!),
                              Styles.infoTitle(
                                  const Icon(Icons.adjust_outlined),
                                  ' Operario: ',
                                  order.camOperario!),
                              Styles.infoTitle(const Icon(Icons.push_pin),
                                  ' Salón: ', order.camSalon.toString()),
                              Styles.infoTitle(
                                  const Icon(Icons.query_stats_rounded),
                                  ' Estado: ',
                                  camEstado(order)),
                              Styles.infoTitle(const Icon(Icons.chat_bubble),
                                  ' Notas: ', order.camNota.toString()),
                              const Divider(),
                              Padding(
                                  padding: espaciado, child: esPagado(order)),
                              const Divider()
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Text('Cliente', style: Styles.textTitleInfo),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Styles.infoTitle(const Icon(Icons.person),
                                  ' Nombre: ', order.cliNombre.toString()),
                              Styles.infoTitle(const Icon(Icons.phone),
                                  ' Teléfono: ', order.cliTelefono.toString()),
                              Styles.infoTitle(const Icon(Icons.place),
                                  ' Dirección:', order.cliDireccion.toString()),
                              Styles.infoTitle(
                                  const Icon(Icons.zoom_in_map_rounded),
                                  ' Zona: ',
                                  order.cliZona.toString()),
                              Styles.infoTitle(const Icon(Icons.chat_bubble),
                                  ' Notas:', order.cliNotas.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Text(
                              'Ticket',
                              style: Styles.textTitleInfo,
                            ),
                          ),
                          _ticketButton(context, order),
                          _ticket(context, order)
                        ],
                      ),
                    ),
                    //OPTIONS LIST INFO
                    widget.config.reparto!.contains("S") &&
                            widget.config.opciones.isNotEmpty
                        ? SizedBox(
                            width: 500,
                            height: 600,
                            child: optionsFutureList(context))
                        : Container()
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0, right: 0, child: CustomIcons.closeBlueBtn(context))
      ],
    );
  }

  Widget optionsFutureList(BuildContext context) {
    return FutureBuilder<ReadOptionsDto?>(
      future: futureOptions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return optionsCheckboxesList(snapshot.data!);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget optionsCheckboxesList(ReadOptionsDto readOptionsDto) {
    ReadOptionsDto newReadOpt = ReadOptionsDto(
        idOrder: widget.order!.camId.toString(),
        opcion1: readOptionsDto.opcion1,
        opcion2: readOptionsDto.opcion2,
        opcion3: readOptionsDto.opcion3,
        opcion4: readOptionsDto.opcion4,
        opcion5: readOptionsDto.opcion5,
        opcion6: readOptionsDto.opcion6,
        opcion7: readOptionsDto.opcion7,
        opcion8: readOptionsDto.opcion8);

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.config.opciones.length,
      itemBuilder: (context, index) {
        //TODO: Ver el estado antes

        bool isChecked = _getOptionValue(newReadOpt, index) == 1 ? true : false;

        return Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: isChecked
                    ? Color.fromARGB(255, 142, 224, 144)
                    : Colors.transparent,
                border: Border.all(color: Styles.black),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: LabeledCheckbox(
              label: widget.config.opciones.elementAt(index),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              value: isChecked,
              onChanged: (bool newValue) {
       /*          newReadOpt.toJson().forEach((key, value) {
                  print("$key : $value");
                }); */
                print(newReadOpt.toJson()["opcion${index + 1}"]);
                setState(() {
                  isChecked = newValue;
                  newReadOpt.toJson()["opcion${index + 1}"] = newValue ? 1 : 0;

                  //print(newReadOpt.toJson().toString());
                });
              },
            )
            /*
             Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool? value) {
                    //TODO: Gestionar cambio de estado
                    //currentOptions!.toJson().keys.elementAt(index);
                    //print(currentOptions!.toJson().keys.elementAt(index));
                    print("CAMBIO");
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text(
                  widget.config.opciones.elementAt(index),
                  style: Styles.textBoldInfo,
                )
              ],
            ) */
            );
      },
    );
  }

  _getOptionValue(ReadOptionsDto option, int index) {
    switch (index) {
      case 0:
        return option.opcion1;
      case 1:
        return option.opcion2;
      case 2:
        return option.opcion3;
      case 3:
        return option.opcion4;
      case 4:
        return option.opcion5;
      case 5:
        return option.opcion6;
      case 6:
        return option.opcion7;
      case 7:
        return option.opcion8;
      default:
        return 1;
    }
  }

  //Cambia el estado de urgencia del botón que se encuentra dentro del diálogo de información
  Widget _ticketButton(BuildContext context, Order order) {
    if (widget.order!.camUrgente.toString() == "0") {
      return TextButton(
          onPressed: () {
            UrgenteDto newUrgent =
                UrgenteDto(idOrder: order.camId.toString(), urgent: '1');

            urgenteRepository.urgente(newUrgent).then((value) {
              widget.socket!.emit(WebSocketEvents.setUrgent,
                  UrgenteDto(idOrder: value.idOrder, urgent: value.urgent));
            });
          },
          child: Container(
            width: 600,
            decoration: BoxDecoration(
              color: Color(0xFFD9534F),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            alignment: Alignment.center,
            height: 50,
            child: Text(
              '¡Marcar como URGENTE!',
              style: Styles.urgent(Styles.urgentDefaultSize),
            ),
          ));
    } else {
      return TextButton(
          onPressed: () {
            UrgenteDto newUrgent =
                UrgenteDto(idOrder: order.camId.toString(), urgent: '0');

            urgenteRepository.urgente(newUrgent).then((value) {
              widget.socket!.emit(WebSocketEvents.setUrgent,
                  UrgenteDto(idOrder: value.idOrder, urgent: value.urgent));
            });
          },
          child: Container(
            width: 600,
            decoration: BoxDecoration(
              color: Color(0xFF5BC0DE),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            alignment: Alignment.center,
            height: 50,
            child: Text(
              '¡Marcar como NO URGENTE!',
              style: Styles.urgent(Styles.urgentDefaultSize),
            ),
          ));
    }
  }

  //Imprime el ticket
  Widget _ticket(BuildContext context, Order order) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 243, 243, 243),
          border: Border.all(
            color: Color.fromARGB(255, 199, 199, 199),

            // red as border color
          ),
        ),
        width: 600,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              utf8.decode(order.camTicket!.runes.toList()),
              style: Styles.textTicketInfo,
            )));
  }
}
