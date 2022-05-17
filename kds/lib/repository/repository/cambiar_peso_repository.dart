import 'package:kds/models/status/cambiar_peso_dto.dart';

abstract class CambiarPesoRepository{
  Future<CambiarPesoDto> urgente(CambiarPesoDto cambiarPesoDto);
}