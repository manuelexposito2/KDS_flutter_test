import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:http/http.dart' as http;
import 'package:kds/utils/constants.dart';


class StatusOrderRepositoryImpl extends StatusOrderRepository{

  @override
  Future<OrderDto> statusOrder(OrderDto orderDto) async{
    String url = 'http://$apiBaseUrl:$puertoKDS/modifyOrderKDS';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    
    final response = 
    await http.post(Uri.parse(url), 
    headers: headers, 
    body: orderDto.toJson());
    
    if(response.statusCode == 200){
     
      return orderDto;
    }else{
      throw Exception('Fail to load');
    }
  }

  
}