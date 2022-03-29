import 'package:kds/models/status/urgente_dto.dart';

abstract class UrgenteRepository{
  Future<void> urgente(UrgenteDto urgenteDto);
}