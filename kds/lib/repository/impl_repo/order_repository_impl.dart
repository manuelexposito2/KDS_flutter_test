import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/utils/constants.dart';
//import 'package:http/http.dart;
import 'dart:js' as js;

import 'package:rikulo_commons/io.dart';
import 'package:rikulo_commons/util.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Client _client = Client();

  //TODO:
  //https://pub.dev/documentation/rikulo_commons/latest/rikulo_io/ajax.html
  //https://api.flutter.dev/flutter/dart-html/HttpRequest-class.html

  @override
  Future<List<Order>> getOrders(String filter) async {
    String url =
        'http://$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter&callback=getLastOrders&_=1647520250758';

    Map<String, String> headers = {
      "callback": "getLastOrders",
      "Access-Control-Allow-Origin": "*"
    };

    final request = await _client.get(Uri.parse(url), headers: headers);

    if (request.statusCode == 501) {
      debugPrint(request.statusCode.toString());
    }

    if (request.statusCode == 200) {
      return LastOrdersResponse.fromJson(jsonDecode(request.body))
          .getLastOrders;
    } else {
      throw Exception(request.body.toString());
    }
  }
}

requestComplete(HttpRequest httpRequest) {
  if (httpRequest.status == 200) {
    final response = httpRequest.responseText;
    if (response != null) {
      LastOrdersResponse.fromJson(jsonDecode(response)).getLastOrders;
      return;
    }
  }
}







/*
  @override
  Future<List<Order>> getOrders(String filter) async {
    //String callback = "?format=json&callback=getLastOrders";

    String url =
        'http://$apiBaseUrl:$puertoPDA/KDS/getOrders.htm?state=$filter&callback=getLastOrders&_=1647520250758';
 



  
    var reqAjax = await ajax(Uri.parse(url), headers: {"callback": "getLastOrders"});
    debugPrint(reqAjax.toString());

      final req = await _client.get(Uri.parse(url), headers: {
      "callback": "getLastOrders",
      "Access-Control_Allow_Origin": "*",
//      "content-type" : "text/html"
    });

    if (req.statusCode == 200) {
      return LastOrdersResponse.fromJson(jsonDecode(req.body)).getLastOrders;
            
    } else {
      //TODO: Gestionar codigos de respuesta
      throw Exception('No se encontraron comandas');
    }
  }
}

Future<List<int>?> ajax(Uri url, {String method = "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse}) async {
      
  final client = HttpClient();
  try {
    final xhr = await client.openUrl(method, url);
    if (headers != null) {
      final xhrheaders = xhr.headers;
      headers.forEach(xhrheaders.add);
    }

    if (data != null) xhr.add(data);
    if (body != null) xhr.write(body);

    final resp = await xhr.close(),
      statusCode = resp.statusCode;

    if (!(onResponse?.call(resp) ?? isHttpStatusOK(statusCode))) {
      resp.listen((event) {
        
      },).asFuture().catchError(throw Exception("No funciona"));
        //need to pull out response.body. Or, it will never ends (memory leak)
      //return null;
    }

    final result = <int>[];
    await resp.listen(result.addAll).asFuture();
    return result;
  } finally {
    InvokeUtil.invokeSafely(client.close);
  }
}


    HttpRequest req = await HttpRequest.request(url,
        method: 'HEAD',
        requestHeaders: {
          "callback": "getLastOrders",
          "Access-Control_Allow_Origin": "*",
        },
        responseType: "jsonp");


Future<List<int>?> ajax(Uri url, {String method: "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    bool? onResponse(HttpClientResponse response)?}) async {
  final client = new HttpClient();
  try {
    final xhr = await client.openUrl(method, url);
    if (headers != null) {
      final xhrheaders = xhr.headers;
      headers.forEach(xhrheaders.add);
    }

    if (data != null) xhr.add(data);
    if (body != null) xhr.write(body);

    final resp = await xhr.close(),
      statusCode = resp.statusCode;

    if (!(onResponse?.call(resp) ?? isHttpStatusOK(statusCode))) {
      resp.listen(_ignore).asFuture().catchError(_voidCatch);
        //need to pull out response.body. Or, it will never ends (memory leak)
      return null;
    }

    final result = <int>[];
    await resp.listen(result.addAll).asFuture();
    return result;
  } finally {
    InvokeUtil.invokeSafely(client.close);
  }
}


 //String url = 'http://192.168.1.43:81/KDS/getOrders.htm?state=T&callback=getLastOrders&_=1647520250758';

  

    final req = await _client.get(Uri.parse(url), headers: {
      "callback": "getLastOrders",
      "Access-Control_Allow_Origin": "*",
     "content-type" : "text/html"
    });
*/
