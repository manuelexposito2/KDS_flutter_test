class UrgenteDto{
  UrgenteDto({
    required this.idOrder,
    required this.urgent
  });

  late final String? idOrder;
  late final String? urgent;

  Map<String, dynamic> toJson(){
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['urgent'] = urgent;
    return _data;
  }
}

