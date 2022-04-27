import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/read_options_dto.dart';

abstract class OptionsRepository {
  Future<ReadOptionsDto?> readOpciones(String id);

  Future<void> writeOpciones(String idOrder, ReadOptionsDto? currentOptions);
}
