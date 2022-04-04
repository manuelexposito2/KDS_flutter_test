import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:kds/bloc/order_by_id/order_by_id_bloc.dart';
import 'package:kds/bloc/status_detail/status_detail_bloc.dart';
import 'package:kds/bloc/status_order/status_order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/models/status/urgente_dto.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/impl_repo/urgent_repository_impl.dart';

import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/repository/repository/urgent_repository.dart';
import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/detail_card.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';

class OrderCard extends StatefulWidget {
  OrderCard({Key? key, required this.order, this.socket}) : super(key: key);

  Socket? socket;
  final Order? order;

  @override
  State<OrderCard> createState() => _ComandaCardState();
}

class _ComandaCardState extends State<OrderCard> {
  late StatusOrderRepository statusOrderRepository;
  late UrgenteRepository urgenteRepository;
  Order? order;
  late StatusOrderBloc statusOrderBloc;
  late StatusDetailBloc statusDetailBloc;
  late OrderByIdBloc orderByIdBloc;

  late OrderRepository orderRepository;

  //Esta comanda es la misma que la principal pero existe para darle más datos
  Future<Order>? orderExtended;

  Color? colorOrderStatus;
  Color? color;
  OrderDto? status;
  late String? showUrgente;

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
    urgenteRepository = UrgentRepositoryImpl();
    orderRepository = OrderRepositoryImpl();
    showUrgente = widget.order!.camUrgente!.toString();
    statusOrderRepository = StatusOrderRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {

       widget.socket!.on(WebSocketEvents.setUrgent, ((data) {
      
      //UrgenteDto newUrgenteDto = UrgenteDto.fromJson(data);
      Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomeScreen(
                          socket: widget.socket,
                        )),
              );
      
    }));

    colorOrderStatus = setColorWithStatus(widget.order!.camEstado!);
    return Container(
      decoration: BoxDecoration(
          color: colorOrderStatus,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(10),
      width: 300,
      child: _contentCard(context, widget.order!),
    );
  }

  setColorWithStatus(String status) {
    switch (status) {
      case "E":
        return Styles.baseColor;

      case "P":
        return Styles.mediumColor;

      case "T":
        return Styles.succesColor;

      default:
        return Styles.baseColor;
    }
  }

  Widget _showUrgente(BuildContext context, Order order) {
    if (showUrgente == "1") {
      return _urgente(context);
    } else {
      return Container();
    }
  }

  Widget _contentCard(BuildContext context, Order order) {
    return Column(
      children: [
        _comandaHeader(context, order),
        _showUrgente(context, order),
        _comandaLineas(context, order)
      ],
    );
  }

  Widget _comandaHeader(BuildContext context, Order order) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total(order) + ' min.',
                style: Styles.regularText,
              ),
              Text(
                //CONTADOR LINEAS ---> Si estan terminadas o en preparandose
                '${order.details.where((element) => element.demEstado!.contains('T') || element.demEstado!.contains('P')).toList().length}/${order.details.toList().length}',
                style: Styles.regularText,
              )
            ],
          ),
        ),
        Container(
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
        ),
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
              Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  width: 40,
                  height: 40,
                  child: IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            orderExtended = orderRepository
                                .getOrderById(widget.order!.camId.toString());

                            return AlertDialog(
                              content: _futureInfo(context),
                            );
                          },
                          barrierDismissible: true),
                      icon: Icon(
                        Icons.info,
                        color: Color.fromARGB(255, 87, 87, 87),
                      ))),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          color: Colors.grey.shade400,
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 195, height: 50, child: _buttonstate(order)),
              SizedBox(
                width: 95,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Color.fromARGB(255, 87, 87, 87)),
                  child: Icon(Icons.print),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonstate(Order order) {
    Text label = const Text('Preparar');
    Icon icon = const Icon(
      Icons.play_arrow,
      color: Color(0xFF337AB7),
      size: 30,
    );

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
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          primary: Color.fromARGB(255, 87, 87, 87),
          textStyle: TextStyle(fontSize: 18)),
      onPressed: () {
        OrderDto newStatus = OrderDto(
            idOrder: order.camId.toString(),
            status: _toogleStateButton(order.camEstado!));

        statusOrderRepository.statusOrder(newStatus).then((value) {
          widget.socket!.emit(WebSocketEvents.modifyOrder,
              OrderDto(idOrder: value.idOrder, status: value.status));
        });

        debugPrint(newStatus.idOrder);
        debugPrint(newStatus.status);
      },
      icon: icon,
      label: label,
    );
  }

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
        for (var d in order.details) DetailCard(details: d, order: order)
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
        style: Styles.urgent,
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

  String total(Order order) {
    var date = DateTime.fromMillisecondsSinceEpoch(order.camFecini! * 1000);
    var date2 = DateTime.now();
    final horatotal = date2.difference(date);
    return horatotal.inMinutes.toString();
  }

  camEstado(Order order) {
    if (order.camEstado == 'E') {
      return Text('En espera', style: Styles.textRegularInfo);
    } else if (order.camEstado == 'P') {
      return Text('En proceso', style: Styles.textRegularInfo);
    } else if (order.camEstado == 'R') {
      return Text('En recogida', style: Styles.textRegularInfo);
    } else if (order.camEstado == 'T') {
      return Text('Terminado', style: Styles.textRegularInfo);
    }
  }

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

  Widget information(BuildContext context, Order order) {
    var espaciado = EdgeInsets.only(bottom: 20);
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Container(
            child: Text(
              'Información de comanda',
              style: Styles.textTitleInfo,
            ),
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              Text(
                                ' Cliente: ',
                                style: Styles.textBoldInfo,
                              ),
                              Text(
                                '',
                                style: Styles.textRegularInfo,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.business_outlined),
                              Text(' Agencia: ', style: Styles.textBoldInfo),
                              Text(" ", style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.adjust_outlined),
                              Text(' Operario: ', style: Styles.textBoldInfo),
                              Text(order.camOperario!,
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.push_pin),
                              Text(' Salón: ', style: Styles.textBoldInfo),
                              Text(order.camSalon.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.query_stats_rounded),
                              Text(' Estado: ', style: Styles.textBoldInfo),
                              camEstado(order),
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble),
                              Text(' Notas: ', style: Styles.textBoldInfo),
                              Text(order.camNota.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(padding: espaciado, child: esPagado(order)),
                        Divider()
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
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              Text(' Nombre: ', style: Styles.textBoldInfo),
                              Text(order.cliNombre.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              Text(' Teléfono: ', style: Styles.textBoldInfo),
                              Text(order.cliTelefono.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.place),
                              Text(' Dirección:', style: Styles.textBoldInfo),
                              Text(order.cliDireccion.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.zoom_in_map_rounded),
                              Text(' Zona: ', style: Styles.textBoldInfo),
                              Text(order.cliZona.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
                        Padding(
                          padding: espaciado,
                          child: Row(
                            children: [
                              Icon(Icons.chat_bubble),
                              Text(' Notas:', style: Styles.textBoldInfo),
                              Text(order.cliNotas.toString(),
                                  style: Styles.textRegularInfo)
                            ],
                          ),
                        ),
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
                    ticket_button(context, order),
                    ticket(context, order)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget ticket_button(BuildContext context, Order order) {
    if (showUrgente == "0") {
      return TextButton(
          onPressed: () {

            /*
            OrderDto newStatus = OrderDto(
            idOrder: order.camId.toString(),
            status: _toogleStateButton(order.camEstado!));

        statusOrderRepository.statusOrder(newStatus).then((value) {
          widget.socket!.emit(WebSocketEvents.modifyOrder,
              OrderDto(idOrder: value.idOrder, status: value.status));
        });
            */

            UrgenteDto newUrgent = UrgenteDto(idOrder: order.camId.toString(), urgent: '1');


        urgenteRepository.urgente
             (newUrgent).then((value) {
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
              style: Styles.urgent,
            ),
          ));
    } else {
      return TextButton(
          onPressed: () {
            widget.socket!.emit(WebSocketEvents.setUrgent,
                UrgenteDto(idOrder: order.camId.toString(), urgent: "0"));
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
              '¡Marcar como NORMAL',
              style: Styles.urgent,
            ),
          ));
    }
  }

  Widget ticket(BuildContext context, Order order) {
    /*
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String result = df.format(
        DateTime.fromMillisecondsSinceEpoch(order.camFecini! * 1000));
    var date =
        DateTime.fromMillisecondsSinceEpoch(order.camFecini! * 1000);
    */
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
              order.camTicket!,
              style: Styles.textTicketInfo,
            )));
  }
}
