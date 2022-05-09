class PrintOrderDto {
  PrintOrderDto({required this.idOrder, required this.idCabecera});

  late final String? idOrder;
  late final String? idCabecera;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['idCabecera'] = idCabecera;
    return _data;
  }

  PrintOrderDto.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    idCabecera = json['idCabecera'];
  }
}