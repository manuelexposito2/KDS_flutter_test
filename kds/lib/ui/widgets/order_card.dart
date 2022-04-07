import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/models/status/urgente_dto.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/impl_repo/urgent_repository_impl.dart';

import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/repository/repository/urgent_repository.dart';

import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/detail_card.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:show_up_animation/show_up_animation.dart';
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

  late OrderRepository orderRepository;

  //Esta comanda es la misma que la principal pero existe para darle más datos
  Future<Order>? orderExtended;

  Color? colorOrderStatus;
  Color? color;
  OrderDto? status;
  //late String? showUrgente;

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
    //showUrgente = widget.order!.camUrgente!.toString();
    statusOrderRepository = StatusOrderRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {
    colorOrderStatus = setColor();
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


  setColor(){
    if(widget.order!.camEstado.toString() == "E"){
      return Styles.baseColor;
    }else if(widget.order!.camEstado.toString() == "P" || widget.order!.details.where((element) => element.demEstado == "P").isNotEmpty){
      return Styles.mediumColor;
    }else if(widget.order!.camEstado.toString() == "T"){
      return Styles.succesColor;
    }else{
      return Styles.baseColor;
    }
  }

  Widget _showUrgente(BuildContext context, Order order) {
    if (widget.order!.camUrgente.toString() == "1") {
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

                            return LayoutBuilder(builder: (BuildContext context, BoxConstraints  constraints) {
                              if (constraints.minWidth > 1700){
                                return AlertDialog(
                              content: _futureInfoBig(context),
                            );
                              }else if(constraints.minWidth > 900){
                                return AlertDialog(
                              content: _futureInfoMedium(context),
                            );
                              }else{
                                return AlertDialog(
                              content: _futureInfoMin(context),
                            );
                              }
                            });
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
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 1),
                  child: SizedBox(
                      width: 195, height: 50, child: _buttonstate(order)),
                ),
              ),
              Expanded(
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

  Widget _futureInfoBig(BuildContext context) {
    return FutureBuilder<Order>(
      future: orderExtended,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return inforBig(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _futureInfoMedium(BuildContext context) {
    return FutureBuilder<Order>(
      future: orderExtended,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return infoMedium(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _futureInfoMin(BuildContext context) {
    return FutureBuilder<Order>(
      future: orderExtended,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return infoMin(context, snapshot.data!);
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
          )
      ],
    );
  }

  Widget _urgente(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Styles.alertColor,
      alignment: Alignment.center,
      height: 65,
      child: Text(
        '¡¡¡URGENTE!!!',
        style: Styles.urgent,
      ),
    );
  }

  String _toogleStateButton(String status) {
    if (widget.order!.camEstado.toString() == "E") {
      return 'P';
    } else if (widget.order!.camEstado.toString() == "P") {
      return 'T';
    } else if (widget.order!.camEstado.toString() == "T"){
      return 'E';
    }else{
      return 'P';
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

  /*
  Widget information(BuildContext context, Order order) {
    var espaciado = EdgeInsets.only(bottom: 20);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.minWidth > 1250) {
          return inforBig(context, order);
        }else if (constraints.minWidth > 900){
          return infoMedium(context, order);
        }else{
          return infoMin(context, order);
        }
      });
  }
  */

  Widget inforBig(BuildContext context, Order order){
    var espaciado = EdgeInsets.only(bottom: 20);
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
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
              ticketContainer(context, order)
            ],
          )
        ],
      ),
    );
  }

  Widget infoMedium(BuildContext context, Order order){
    var espaciado = EdgeInsets.only(bottom: 20);
    return SingleChildScrollView(child: Container(
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
            children: [
              Container(
                width: 350,
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
                width: 350,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Cliente',
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
            ],
          ),
          Container(margin: EdgeInsets.all(20),child: ticketContainer(context, order))
        ],
      ),
    ),);
  }


  Widget infoMin(BuildContext context, Order order){
    var espaciado = EdgeInsets.only(bottom: 20);
    return SingleChildScrollView(child: Container(
      child: Column(
        children: [
          Container(
            child: Text(
              'Información de comanda',
              style: Styles.textTitleInfo,
            ),
          ),
          Divider(),
          Column(
            children: [
              Container(
                width: 350,
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
                width: 350,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Cliente',
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
            ],
          ),
          Container(margin: EdgeInsets.all(20),child: ticketContainerMin(context, order))
        ],
      ),
    ),);
  }

  Widget ticketContainer(BuildContext context, Order order){
    return Container(
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
              );
  }

  Widget ticketContainerMin(BuildContext context, Order order){
    return Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Ticket',
                        style: Styles.textTitleInfo,
                      ),
                    ),
                    ticket_buttonMin(context, order),
                    ticketMin(context, order)
                  ],
                ),
              );
  }

  Widget ticket_button(BuildContext context, Order order) {
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
              style: Styles.urgent,
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
              '¡Marcar como NORMAL',
              style: Styles.urgent,
            ),
          ));
    }
  }

  Widget ticket_buttonMin(BuildContext context, Order order) {
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
            width: 400,
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
              '¡Marcar como NORMAL',
              style: Styles.urgent,
            ),
          ));
    }
  }

  Widget ticket(BuildContext context, Order order) {

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

  Widget ticketMin(BuildContext context, Order order) {

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 243, 243, 243),
          border: Border.all(
            color: Color.fromARGB(255, 199, 199, 199),

            // red as border color
          ),
        ),
        width: 400,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              order.camTicket!,
              style: Styles.textTicketInfo,
            )));
  }
}

