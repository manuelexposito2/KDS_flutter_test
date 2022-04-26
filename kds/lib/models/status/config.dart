class Config {
  Config({
    required this.urlPDA,
    required this.sonido,
    required this.reparto,
    required this.modo,
    required this.comandaCompleta,
    required this.muestraOperario,
    required this.letra,
    required this.pedidosRecoger,
    required this.comandasRecoger,
    required this.mostrarContadores,
    required this.mostrarMensajes,
    required this.seleccionarOperario,
    required this.confirmarCerrar,
    required this.mostrarUltimoTiempo,
    required this.soloUltimoPlato,
    required this.comandasPreparar,
    required this.pedidosPreparar,
    required this.imprimirPendienteCobro,
    required this.detallesRecoger,
    required this.opciones,
    required this.noImprimirCambioOperario,
    required this.modificarPeso,
  });
  late final String? urlPDA;
  late final String? sonido;
  late final String? reparto;
  late final String? modo;
  late final String? comandaCompleta;
  late final String? muestraOperario;
  late final String? letra;
  late final String? pedidosRecoger;
  late final String? comandasRecoger;
  late final String? mostrarContadores;
  late final String? mostrarMensajes;
  late final String? seleccionarOperario;
  late final String? confirmarCerrar;
  late final String? mostrarUltimoTiempo;
  late final String? soloUltimoPlato;
  late final String? comandasPreparar;
  late final String? pedidosPreparar;
  late final String? imprimirPendienteCobro;
  late final String? detallesRecoger;
  late final List<dynamic> opciones;
  late final String? noImprimirCambioOperario;
  late final String? modificarPeso;
  
  Config.fromJson(Map<String, dynamic> json){
    urlPDA = json['UrlPDA'];
    sonido = json['Sonido'];
    reparto = json['Reparto'];
    modo = json['Modo'];
    comandaCompleta = json['Comanda_completa'];
    muestraOperario = json['Muestra_operario'];
    letra = json['Letra'];
    pedidosRecoger = json['Pedidos_recoger'];
    comandasRecoger = json['Comandas_recoger'];
    mostrarContadores = json['Mostrar_contadores'];
    mostrarMensajes = json['Mostrar_mensajes'];
    seleccionarOperario = json['Seleccionar_operario'];
    confirmarCerrar = json['Confirmar_cerrar'];
    mostrarUltimoTiempo = json['Mostrar_ultimo_tiempo'];
    soloUltimoPlato = json['Solo_ultimo_plato'];
    comandasPreparar = json['Comandas_preparar'];
    pedidosPreparar = json['Pedidos_preparar'];
    imprimirPendienteCobro = json['Imprimir_pendiente_cobro'];
    detallesRecoger = json['Detalles_recoger'];
    opciones = List.castFrom<dynamic, dynamic>(json['Opciones']);
    noImprimirCambioOperario = json['No_imprimir_cambio_operario'];
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
    _data['Pedidos_recoger'] = pedidosRecoger;
    _data['Comandas_recoger'] = comandasRecoger;
    _data['Mostrar_contadores'] = mostrarContadores;
    _data['Mostrar_mensajes'] = mostrarMensajes;
    _data['Seleccionar_operario'] = seleccionarOperario;
    _data['Confirmar_cerrar'] = confirmarCerrar;
    _data['Mostrar_ultimo_tiempo'] = mostrarUltimoTiempo;
    _data['Solo_ultimo_plato'] = soloUltimoPlato;
    _data['Comandas_preparar'] = comandasPreparar;
    _data['Pedidos_preparar'] = pedidosPreparar;
    _data['Imprimir_pendiente_cobro'] = imprimirPendienteCobro;
    _data['Detalles_recoger'] = detallesRecoger;
    _data['Opciones'] = opciones;
    _data['No_imprimir_cambio_operario'] = noImprimirCambioOperario;
    _data['Modificar_peso'] = modificarPeso;
    return _data;
  }
}