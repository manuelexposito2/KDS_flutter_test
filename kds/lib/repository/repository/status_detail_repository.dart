import 'package:kds/models/status/detail_dto.dart';

abstract class StatusDetailRepository{
  Future<void> statusDetail(DetailDto detailDto);
}