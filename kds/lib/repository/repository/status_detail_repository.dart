import 'package:kds/models/status/detail_dto.dart';

abstract class StatusDetailRepository{
  Future<DetailDto> statusDetail(DetailDto detailDto);
}