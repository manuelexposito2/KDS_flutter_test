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
  late final String idOrder;
  late final int opcion1;
  late final int opcion2;
  late final int opcion3;
  late final int opcion4;
  late final int opcion5;
  late final int opcion6;
  late final int opcion7;
  late final int opcion8;

  ReadOptionsDto.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    opcion1 = json['opcion1'];
    opcion2 = json['opcion2'];
    opcion3 = json['opcion3'];
    opcion4 = json['opcion4'];
    opcion5 = json['opcion5'];
    opcion6 = json['opcion6'];
    opcion7 = json['opcion7'];
    opcion8 = json['opcion8'];
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
