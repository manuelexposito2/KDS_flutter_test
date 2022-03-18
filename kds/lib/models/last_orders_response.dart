

class LastOrdersResponse {
  LastOrdersResponse(
    {
    required this.getLastOrders,
  });
  late final List<Order> getLastOrders;
  
  
  LastOrdersResponse.fromJson(Map<String, dynamic> json){
    getLastOrders = List.from(json['getLastOrders']).map((e)=>Order.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['getLastOrders'] = getLastOrders.map((e)=>e.toJson()).toList();
    
    return _data;
  }
}

class Order {
  Order({
    required this.camId,
    required this.camUrgente,
    required this.camIdCab,
    required this.camFecini,
    required this.camFecfin,
    required this.camOperario,
    required this.camEstado,
    required this.camMesa,
    required this.camOrden,
    required this.camSalon,
    required this.camNombre,
    required this.camName,
    required this.numPedido,
    required this.camNota,
    required this.camComensales,
    required this.camPedido,
    required this.camEstadoCab,
    required this.camTipoPedido,
    required this.camHora,
    required this.camMin,
    required this.numPedidoOnline,
    required this.details,
  });
  late final int camId;
  late final int camUrgente;
  late final int camIdCab;
  late final int camFecini;
  late final int camFecfin;
  late final String camOperario;
  late final String camEstado;
  late final int camMesa;
  late final int camOrden;
  late final String camSalon;
  late final String camNombre;
  late final String camName;
  late final String numPedido;
  late final String camNota;
  late final int camComensales;
  late final int camPedido;
  late final String camEstadoCab;
  late final String camTipoPedido;
  late final String camHora;
  late final String camMin;
  late final String numPedidoOnline;
  late final List<Details> details;
  
  Order.fromJson(Map<String, dynamic> json){
    camId = json['cam_id'];
    camUrgente = json['cam_urgente'];
    camIdCab = json['cam_id_cab'];
    camFecini = json['cam_fecini'];
    camFecfin = json['cam_fecfin'];
    camOperario = json['cam_operario'];
    camEstado = json['cam_estado'];
    camMesa = json['cam_mesa'];
    camOrden = json['cam_orden'];
    camSalon = json['cam_salon'];
    camNombre = json['cam_nombre'];
    camName = json['cam_name'];
    numPedido = json['num_pedido'];
    camNota = json['cam_nota'];
    camComensales = json['cam_comensales'];
    camPedido = json['cam_pedido'];
    camEstadoCab = json['cam_estado_cab'];
    camTipoPedido = json['cam_tipo_pedido'];
    camHora = json['cam_hora'];
    camMin = json['cam_min'];
    numPedidoOnline = json['num_pedido_online'];
    details = List.from(json['details']).map((e)=>Details.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['cam_id'] = camId;
    _data['cam_urgente'] = camUrgente;
    _data['cam_id_cab'] = camIdCab;
    _data['cam_fecini'] = camFecini;
    _data['cam_fecfin'] = camFecfin;
    _data['cam_operario'] = camOperario;
    _data['cam_estado'] = camEstado;
    _data['cam_mesa'] = camMesa;
    _data['cam_orden'] = camOrden;
    _data['cam_salon'] = camSalon;
    _data['cam_nombre'] = camNombre;
    _data['cam_name'] = camName;
    _data['num_pedido'] = numPedido;
    _data['cam_nota'] = camNota;
    _data['cam_comensales'] = camComensales;
    _data['cam_pedido'] = camPedido;
    _data['cam_estado_cab'] = camEstadoCab;
    _data['cam_tipo_pedido'] = camTipoPedido;
    _data['cam_hora'] = camHora;
    _data['cam_min'] = camMin;
    _data['num_pedido_online'] = numPedidoOnline;
    _data['details'] = details.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Details {
  Details({
    required this.demId,
    required this.demIdCam,
    required this.demEstado,
    required this.demFecini,
    required this.demFecfin,
    required this.demArti,
    required this.demTitulo,
    required this.demSubpro,
    required this.demSubext,
    required this.demSubopc,
    required this.demModi,
    required this.demMensa,
    required this.demOrden,
    required this.demName,
    required this.demSeling,
    required this.demPlato,
    required this.demPedirPeso,
  });
  late final int demId;
  late final int demIdCam;
  late final String demEstado;
  late final int demFecini;
  late final int demFecfin;
  late final String demArti;
  late final String demTitulo;
  late final String demSubpro;
  late final String demSubext;
  late final String demSubopc;
  late final String demModi;
  late final String demMensa;
  late final int demOrden;
  late final String demName;
  late final int demSeling;
  late final int demPlato;
  late final int demPedirPeso;
  
  Details.fromJson(Map<String, dynamic> json){
    demId = json['dem_id'];
    demIdCam = json['dem_id_cam'];
    demEstado = json['dem_estado'];
    demFecini = json['dem_fecini'];
    demFecfin = json['dem_fecfin'];
    demArti = json['dem_arti'];
    demTitulo = json['dem_titulo'];
    demSubpro = json['dem_subpro'];
    demSubext = json['dem_subext'];
    demSubopc = json['dem_subopc'];
    demModi = json['dem_modi'];
    demMensa = json['dem_mensa'];
    demOrden = json['dem_orden'];
    demName = json['dem_name'];
    demSeling = json['dem_seling'];
    demPlato = json['dem_plato'];
    demPedirPeso = json['dem_pedir_peso'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dem_id'] = demId;
    _data['dem_id_cam'] = demIdCam;
    _data['dem_estado'] = demEstado;
    _data['dem_fecini'] = demFecini;
    _data['dem_fecfin'] = demFecfin;
    _data['dem_arti'] = demArti;
    _data['dem_titulo'] = demTitulo;
    _data['dem_subpro'] = demSubpro;
    _data['dem_subext'] = demSubext;
    _data['dem_subopc'] = demSubopc;
    _data['dem_modi'] = demModi;
    _data['dem_mensa'] = demMensa;
    _data['dem_orden'] = demOrden;
    _data['dem_name'] = demName;
    _data['dem_seling'] = demSeling;
    _data['dem_plato'] = demPlato;
    _data['dem_pedir_peso'] = demPedirPeso;
    return _data;
  }
}