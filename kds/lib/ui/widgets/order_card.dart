import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kds/bloc/status_detail/status_detail_bloc.dart';
import 'package:kds/bloc/status_order/status_order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/impl_repo/status_detail_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/ui/styles/styles.dart';

class OrderCard extends StatefulWidget {
  OrderCard({Key? key, required this.order}) : super(key: key);

  final Order? order;

  @override
  State<OrderCard> createState() => _ComandaCardState();
}

class _ComandaCardState extends State<OrderCard> {
  late StatusOrderRepository statusOrderRepository;
  late StatusDetailRepository statusDetailRepository;
  late StatusOrderBloc statusOrderBloc;
  late StatusDetailBloc statusDetailBloc;

  String? idOrder;
  String? idDetail;
  String? status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusOrderRepository = StatusOrderRepositoryImpl();
    statusDetailRepository = StatusDetailRepositoryImpl();
    statusOrderBloc = StatusOrderBloc(statusOrderRepository)
      ..add(DoStatusOrderEvent(OrderDto(idOrder: idOrder, status: status)));
    statusDetailBloc = StatusDetailBloc(statusDetailRepository)
      ..add(DoStatusDetailEvent(
          DetailDto(idOrder: idOrder, idDetail: idDetail, status: status)));
  }

  @override
  Widget build(BuildContext context) {
    return cardComanda(context);

    /*MultiBlocListener(
  listeners: [
    BlocListener<StatusOrderBloc, StatusOrderSuccessState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocB, BlocBState>(
      listener: (context, state) {},
    ),
  ],
  child: ChildA(),
)*/
  }

  Widget cardComanda(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Styles.succesColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(10),
      width: 300,
      child: Wrap(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      total() + ' min.',
                      style: Styles.regularText,
                    ),
                    Text(
                      '1/5',
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
                      widget.order!.camOperario,
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
                          widget.order!.camMesa.toString(),
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
                                  return AlertDialog(
                                    content: information(),
                                  );
                                },
                                barrierDismissible: true),
                            icon: Icon(
                              Icons.info,
                              color: Color.fromARGB(255, 87, 87, 87),
                            )))
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.grey.shade400,
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 195,
                  height: 50,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Color.fromARGB(255, 87, 87, 87),
                        textStyle: TextStyle(fontSize: 18)),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color(0xFF337AB7),
                      size: 30,
                    ),
                    label: const Text(
                      'Preparar',
                    ),
                  ),
                ),
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
          //urgente(),
          Container(
            margin: EdgeInsets.all(1),
            color: Colors.white,
            child: cardItem(context, widget.order!.details),
          )
        ],
      ),
    );
  }

  Widget urgente() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Styles.alertColor,
      alignment: Alignment.center,
      height: 50,
      //Hacer condición de que solo sale este espacio si se da tap en el botón de urgente
      child: Text(
        '¡¡¡URGENTE!!!',
        style: Styles.urgent,
      ),
    );
  }

  Widget _itemPedido(BuildContext context, Details details) {
    details.demEstado.contains('E');
    details.demEstado.contains('R');
    details.demEstado.contains('P');
    details.demEstado.contains('T');
    Color nuevo = Colors.white;

    if (details.demEstado.contains('E')) {
      nuevo = Colors.white;
    } else if (details.demEstado.contains('P')) {
      nuevo = Color(0xFFF5CB8F);
    } else if (details.demEstado.contains('R')) {
      nuevo = Colors.purple;
    } else if (details.demEstado.contains('T')) {
      nuevo = Color(0xFFB0E1A0);
    } else {
      nuevo = Colors.white;
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: nuevo,
        primary: Color.fromARGB(255, 87, 87, 87),
      ),
      onPressed: () {
        _toogleStateButton(details);
      },
      child: ListTile(
        title: Text(
          details.demTitulo,
          style: Styles.textTitle,
        ),
      ),
    );
  }

  Widget cardItem(BuildContext context, List<Details> details) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [for (var d in details) _itemPedido(context, d)],
    );
  }

  void _toogleStateButton(Details details) {
    setState(() {
      if (details.demEstado.contains('E')) {
        details.demEstado = 'P';
      } else if (details.demEstado.contains('P')) {
        details.demEstado = 'T';
      } else {
        details.demEstado = 'E';
      }
    });
  }

  String total() {
    var date =
        DateTime.fromMillisecondsSinceEpoch(widget.order!.camFecini * 1000);
    var date2 = DateTime.now();
    final horatotal = date2.difference(date);
    return horatotal.inMinutes.toString();
  }

  Widget information() {
    var espaciado = EdgeInsets.only(bottom: 5);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 450,
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
                                  'Nombre del cliente',
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
                                Text('Nombre de la agencia',
                                    style: Styles.textRegularInfo)
                              ],
                            ),
                          ),
                          Padding(
                            padding: espaciado,
                            child: Row(
                              children: [
                                Icon(Icons.adjust_outlined),
                                Text(' Operario: ', style: Styles.textBoldInfo),
                                Text('Nombre del operario',
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
                                Text('Número del salon',
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
                                Text('En espera', style: Styles.textRegularInfo)
                              ],
                            ),
                          ),
                          Padding(
                            padding: espaciado,
                            child: Row(
                              children: [
                                Icon(Icons.chat_bubble),
                                Text(' Notas: ', style: Styles.textBoldInfo),
                                Text('Ejemplo de notas',
                                    style: Styles.textRegularInfo)
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: espaciado,
                            child: Row(
                              children: [
                                Icon(Icons.euro_outlined),
                                Text(' Pagado: ', style: Styles.textBoldInfo),
                                /* */ Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 40,
                                ),
                                Text('Si', style: Styles.textRegularInfo)
                              ],
                            ),
                          ),
                          Divider()
                        ],
                      )
                    ],
                  ),
                ),
                Container(
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
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                Text(' Nombre: ', style: Styles.textBoldInfo),
                                Text('Nombre del cliente',
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
                                Text('Teléfono', style: Styles.textRegularInfo)
                              ],
                            ),
                          ),
                          Padding(
                            padding: espaciado,
                            child: Row(
                              children: [
                                Icon(Icons.place),
                                Text(' Dirección:', style: Styles.textBoldInfo),
                                Text('Dirección del cliente',
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
                                Text('Zona en la que se encuentra',
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
                                Text('Ejemplo de notas',
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
                      TextButton(
                          onPressed: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFD9534F),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            alignment: Alignment.center,
                            height: 50,
                            width: 350,
                            child: Text(
                              '¡Marcar como URGENTE!',
                              style: Styles.urgent,
                            ),
                          )),
                      ticket(context)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget ticket(BuildContext context) {

    var date =
        DateTime.fromMillisecondsSinceEpoch(widget.order!.camFecini * 1000);
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
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                'Fecha: ',
                                style: Styles.textTicketInfo,
                              ),
                              Text(
                                date.toString(),
                                style: Styles.textTicketInfo,
                              )
                            ],
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 170),
                        child: Text('Articulo', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('Ud', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('Precio', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Importe', style: Styles.textTicketInfo),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: List.generate(
                          300 ~/ 5,
                          (index) => Expanded(
                                child: Container(
                                  color: index % 2 == 0
                                      ? Colors.transparent
                                      : Color.fromARGB(255, 0, 0, 0),
                                  height: 1,
                                ),
                              )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 170),
                        child: Text('Articulo', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('Ud', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('Precio', style: Styles.textTicketInfo),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text('Importe', style: Styles.textTicketInfo),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: List.generate(
                      300 ~/ 5,
                      (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Color.fromARGB(255, 0, 0, 0),
                              height: 1,
                            ),
                          )),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Total EUR:', style: Styles.textTicketInfo),
                    Text('7.00', style: Styles.textTicketInfo)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  /*
  Widget urgente() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Styles.alertColor,
      alignment: Alignment.center,
      height: 50,
      //Hacer condición de que solo sale este espacio si se da tap en el botón de urgente
      child: Text(
        '¡¡¡URGENTE!!!',
        style: Styles.urgent,
      ),
    );
  }
  */
}
