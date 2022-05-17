class CambiarPesoDto {
  CambiarPesoDto({required this.idOrder, required this.idDetail, required this.pesoAnterior, required this.nuevoPeso});

  late final String? idOrder;
  late final String? idDetail;
  late final String? pesoAnterior;
  late final String? nuevoPeso;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['idDetail'] = idDetail;
    _data['pesoAnterior'] = pesoAnterior;
    _data['nuevoPeso'] = nuevoPeso;
    return _data;
  }

  CambiarPesoDto.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    idDetail = json['idDetail'];
    pesoAnterior = json['pesoAnterior'];
    nuevoPeso = json['nuevoPeso'];
  }
}