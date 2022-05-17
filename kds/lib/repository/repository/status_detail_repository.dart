import 'package:kds/models/status/cambiar_peso_dto.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/detail_dto.dart';

abstract class StatusDetailRepository {
  Future<DetailDto> statusDetail(DetailDto detailDto);
  
  Future<CambiarPesoDto> cambiarPeso(CambiarPesoDto cambiarPesoDto);
}
