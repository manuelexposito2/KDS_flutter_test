class SetDealersResponse {
  SetDealersResponse({
    required this.setDealer,
  });
  late final SetDealer setDealer;
  
  SetDealersResponse.fromJson(Map<String, dynamic> json){
    setDealer = SetDealer.fromJson(json['setDealer']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['setDealer'] = setDealer.toJson();
    return _data;
  }
}

class SetDealer {
  SetDealer({
    required this.status,
  });
  late final String status;
  
  SetDealer.fromJson(Map<String, dynamic> json){
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}