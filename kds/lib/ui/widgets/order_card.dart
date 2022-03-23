import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    statusOrderBloc = StatusOrderBloc(statusOrderRepository)..add(DoStatusOrderEvent(OrderDto(idOrder: idOrder, status: status)));
    statusDetailBloc = StatusDetailBloc(statusDetailRepository)..add(DoStatusDetailEvent(DetailDto(idOrder: idOrder, idDetail: idDetail,status: status)));
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

  Widget cardComanda(BuildContext context){
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
                            onPressed: () {},
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
            child: pruebaItem(context, widget.order!.details),
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

  Widget pruebaItem(BuildContext context, List<Details> details) {
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
}
