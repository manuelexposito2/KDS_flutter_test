import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'dart:async';
import 'dart:convert';

import './../../utils/string_extension.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/utils/constants.dart';

class Repository {
  Map<String, String> headers = {
    "callback": "getLastOrders",
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "text/html"
  };

  Future<List<Order>> getOrders(String filter) async {
    String url =
        'http://$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter';

    final request = await http.get(Uri.parse(url), headers: headers);
    debugPrint(request.statusCode.toString());
    if (request.statusCode == 200) {
      return LastOrdersResponse.fromJson(jsonDecode(_jsonpToJson(request)))
          .getLastOrders;
    } else {
      throw Exception(request.body.toString());
    }
  }

  Stream<List<Order?>> fetchOrders(String filter) async* {
    String url =
        'http://$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter';

    final request = await http.get(Uri.parse(url), headers: headers);

    if (request.statusCode == 200) {
      yield LastOrdersResponse.fromJson(jsonDecode(_jsonpToJson(request)))
          .getLastOrders;
    } else {
      throw Exception(request.body.toString());
    }
  }

  Future<Order> getOrderById(String id) async {
    String url = 'http://$apiBaseUrl:$puertoPDA/KDS/getIdOrder.htm?id=$id';

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

  Future<DetailDto> statusDetail(DetailDto detailDto) async {
    String url = 'http://$apiBaseUrl:$puertoKDS/modifyDetailKDS';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: detailDto.toJson());

    if (response.statusCode == 200) {
      return detailDto;
    } else {
      throw Exception('Fail to load');
    }
  }

  Future<OrderDto> statusOrder(OrderDto orderDto) async {
    String url = 'http://$apiBaseUrl:$puertoKDS/modifyOrderKDS';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: orderDto.toJson());

    if (response.statusCode == 200) {
      return orderDto;
    } else {
      throw Exception('Fail to load');
    }
  }

  _jsonpToJson(http.Response request) {
    var callback = "getLastOrders";
    var dataBody = request.body.strip("(").strip(")");
    var json = "{${dataBody.replaceAll(callback, '"$callback":')}}";

    if (json.contains('ï»¿')) {
      return json.replaceAll('ï»¿', "");
    }

    return json;
  }
}
