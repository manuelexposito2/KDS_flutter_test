class WriteOptionsDto {
  WriteOptionsDto({
    required this.data,
  });
  late final Data data;
  
  WriteOptionsDto.fromJson(Map<String, dynamic> json){
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.idOrder,
    required this.opcion1,
    required this.opcion2,
    required this.opcion3,
    required this.opcion4,
    required this.opcion5,
    required this.opcion6,
    required this.opcion7,
    required this.opcion8,
  });
  late final String idOrder;
  late final int opcion1;
  late final int opcion2;
  late final int opcion3;
  late final int opcion4;
  late final int opcion5;
  late final int opcion6;
  late final int opcion7;
  late final int opcion8;
  
  Data.fromJson(Map<String, dynamic> json){
    idOrder = json['idOrder'];
    opcion1 = json['aopcion1'];
    opcion2 = json['bopcion2'];
    opcion3 = json['copcion3'];
    opcion4 = json['dopcion4'];
    opcion5 = json['eopcion5'];
    opcion6 = json['fopcion6'];
    opcion7 = json['gopcion7'];
    opcion8 = json['hopcion8'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['opcion1'] = opcion1;
    _data['opcion2'] = opcion2;
    _data['opcion3'] = opcion3;
    _data['opcion4'] = opcion4;
    _data['opcion5'] = opcion5;
    _data['opcion6'] = opcion6;
    _data['opcion7'] = opcion7;
    _data['opcion8'] = opcion8;
    return _data;
  }
}