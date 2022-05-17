class ReadOptionsDto {
  ReadOptionsDto({
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
  late final dynamic idOrder;
  late final dynamic opcion1;
  late final dynamic opcion2;
  late final dynamic opcion3;
  late final dynamic opcion4;
  late final dynamic opcion5;
  late final dynamic opcion6;
  late final dynamic opcion7;
  late final dynamic opcion8;
  
  ReadOptionsDto.fromJson(Map<String, dynamic> json){
    idOrder = json['idOrder'];
    opcion1 = json['opcion1'] ?? 0 ;
    opcion2 = json['opcion2'] ?? 0 ;
    opcion3 = json['opcion3'] ?? 0 ;
    opcion4 = json['opcion4'] ?? 0 ;
    opcion5 = json['opcion5'] ?? 0 ;
    opcion6 = json['opcion6'] ?? 0 ;
    opcion7 = json['opcion7'] ?? 0 ;
    opcion8 = json['opcion8'] ?? 0 ;
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

    // {data : {idOrder ....}}
  }
}
