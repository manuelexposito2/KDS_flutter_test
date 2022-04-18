class GetWorkersResponse {
  GetWorkersResponse({
    required this.getWorkers,
  });
  late final List<GetWorkers> getWorkers;
  
  GetWorkersResponse.fromJson(Map<String, dynamic> json){
    getWorkers = List.from(json['getWorkers']).map((e)=>GetWorkers.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['getWorkers'] = getWorkers.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GetWorkers {
  GetWorkers({
    required this.oprCodigo,
    required this.oprNombre,
  });
  late final String oprCodigo;
  late final String oprNombre;
  
  GetWorkers.fromJson(Map<String, dynamic> json){
    oprCodigo = json['opr_codigo'];
    oprNombre = json['opr_nombre'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['opr_codigo'] = oprCodigo;
    _data['opr_nombre'] = oprNombre;
    return _data;
  }
}