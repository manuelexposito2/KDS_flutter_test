class Config {
  Config({
    required this.urlPDA,
    required this.sonido,
    required this.reparto,
    required this.modo,
    required this.comandaCompleta,
    required this.muestraOperario,
    required this.letra,
    required this.seleccionarOperario,
    required this.opciones,
    required this.modificarPeso,
  });
  late final String? urlPDA;
  late final String? sonido;
  late final String? reparto;
  late final String? modo;
  late final String? comandaCompleta;
  late final String? muestraOperario;
  late final String? letra;
  late final String? seleccionarOperario;
  late final List<dynamic> opciones;
  late final String? modificarPeso;
  
  Config.fromJson(Map<String, dynamic> json){
    urlPDA = json['UrlPDA'];
    sonido = json['Sonido'];
    reparto = json['Reparto'];
    modo = json['Modo'];
    comandaCompleta = json['Comanda_completa'];
    muestraOperario = json['Muestra_operario'];
    letra = json['Letra'];
    seleccionarOperario = json['Seleccionar_operario'];
    opciones = List.castFrom<dynamic, dynamic>(json['Opciones']);
    modificarPeso = json['Modificar_peso'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['UrlPDA'] = urlPDA;
    _data['Sonido'] = sonido;
    _data['Reparto'] = reparto;
    _data['Modo'] = modo;
    _data['Comanda_completa'] = comandaCompleta;
    _data['Muestra_operario'] = muestraOperario;
    _data['Letra'] = letra;
    _data['Seleccionar_operario'] = seleccionarOperario;
    _data['Opciones'] = opciones;
    _data['Modificar_peso'] = modificarPeso;
    return _data;
  }
}