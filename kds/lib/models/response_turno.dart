class ResponseTurnoCallback {
  ResponseTurnoCallback({
    required this.responseTurno,
  });
  late final ResponseTurno responseTurno;

  ResponseTurnoCallback.fromJson(Map<String, dynamic> json) {
    responseTurno = ResponseTurno.fromJson(json['responseTurno']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['responseTurno'] = responseTurno.toJson();
    return _data;
  }
}

class ResponseTurno {
  ResponseTurno({
    required this.mod,
    required this.status,
    required this.message,
    required this.operario,
    required this.hora,
  });
  late final String mod;
  late final String status;
  late final String message;
  late final String? operario;
  late final String? hora;

  ResponseTurno.fromJson(Map<String, dynamic> json) {
    mod = json['mod'];
    status = json['status'];
    message = json['message'];
    operario = json['operario'];
    hora = json['hora'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mod'] = mod;
    _data['status'] = status;
    _data['message'] = message;
    _data['operario'] = operario;
    _data['hora'] = hora;
    return _data;
  }
}
