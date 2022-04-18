import 'dart:async';
import 'dart:convert';

import 'package:kds/models/status/config.dart';

import './../../utils/string_extension.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/utils/constants.dart';
//import 'package:http/http.dart;

class OrderRepositoryImpl implements OrderRepository {
  Map<String, String> headers = {
    "callback": "getLastOrders",
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "text/html"
  };

  @override
  Future<List<Order>> getOrders(String filter, Config config) async {
    //String url ='http://$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter';

    String url = '${config.urlPDA}/KDS/getOrders.htm?state=$filter';

    final request = await http.get(Uri.parse(url), headers: headers);
    debugPrint(request.statusCode.toString());
    if (request.statusCode == 200) {
      return LastOrdersResponse.fromJson(jsonDecode(_jsonpToJson(request)))
          .getLastOrders;
    } else {
      throw Exception(request.body.toString());
    }
  }

  @override
  Future<Order> getOrderById(String id, Config config) async {
    //String url = 'http://$apiBaseUrl:$puertoPDA/KDS/getIdOrder.htm?id=$id';
    String url = '${config.urlPDA}/KDS/getIdOrder.htm?id=$id';
    final request = await http.get(Uri.parse(url), headers: headers);
    

    if (request.statusCode == 200) {
      return LastOrdersResponse.fromJson(jsonDecode(_jsonpToJson(request)))
          .getLastOrders
          .where((element) => element.camId == int.parse(id))
          .first;
    } else {
      throw Exception(request.statusCode);
    }
  }

  _jsonpToJson(http.Response request) {
    var callback = "getLastOrders";
    var dataBody = request.body.strip("(").strip(")");
    var json = "{${dataBody.replaceAll(callback, '"$callback":')}}";

    if(json.contains('ï»¿')) {

     return json.replaceAll('ï»¿', "");
    }

    return json;
  }

}
