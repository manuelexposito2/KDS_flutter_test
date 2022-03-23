import 'dart:convert';

import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:http/http.dart' as http;
import 'package:kds/utils/constants.dart';


class StatusOrderRepositoryImpl extends StatusOrderRepository{

  @override
  Future<void> statusOrder(OrderDto orderDto) async{
    String url = 'http://$apiBaseUrl:$puertoKDS/modifyOrderKDS';
    Map<String, String> headers = {
      "callback": "getLastOrders",
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "text/plain"
    };

    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: jsonEncode(orderDto.toJson()));

    if(response.statusCode == 200){
      
    }else{
      throw Exception('Fail to load');
    }
  }

  
}