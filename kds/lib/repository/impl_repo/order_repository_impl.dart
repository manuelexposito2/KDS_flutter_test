

import 'dart:convert';

import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderRepositoryImpl implements OrderRepository{
  
  
  @override
  Future<List<Order>> getOrders(String filter) async {
      //ruta --> localhost:81/KDS/getOrders.htm?state=prepare
  String url = '$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter';

  final response = await http.get(Uri.parse(url));


  if (response.statusCode == 200){

    return LastOrdersResponse.fromJson(jsonDecode(response.body)).getLastOrders;
  } else{
    //TODO: Gestionar codigos de respuesta
    throw Exception('No se encontraron comandas');
  }


    
  }



}