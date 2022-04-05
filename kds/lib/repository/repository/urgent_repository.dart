import 'package:kds/models/status/urgente_dto.dart';

abstract class UrgenteRepository{
  Future<UrgenteDto> urgente(UrgenteDto urgenteDto);
}