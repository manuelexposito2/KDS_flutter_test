class DetailDto{

  /*
  "idOrder": "8",
    "idDetail": "25",
    "status": "T"
  */
  DetailDto({
    required this.idOrder,
    required this.idDetail,
    required this.status
  });
  late final String? idOrder;
  late final String? idDetail;
  late final String? status;

  Map<String, dynamic> toJson(){
    final _data = <String, dynamic>{};
    _data['idOrder'] = idOrder;
    _data['idDetail'] = idDetail;
    _data['status'] = status;
    return _data;
  }
}