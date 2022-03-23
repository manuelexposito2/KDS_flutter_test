import 'package:flutter/material.dart';

class OrderDto{
  OrderDto({
    required this.idOrder,
    required this.status
  });

  late final String? idOrder;
  late final String? status;

  Map<String, dynamic> toJson(){
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['status'] = status;
    return _data;
  }
}