import 'package:http/http.dart' as http;
import 'package:kds/models/status/cambiar_peso_dto.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/utils/constants.dart';

class StatusDetailRepositoryImpl
    implements StatusDetailRepository {
  @override
  Future<DetailDto> statusDetail(DetailDto detailDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = '$urlKDS/modifyDetailKDS';

    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: detailDto.toJson());

    if (response.statusCode == 200) {
      return detailDto;
    } else {
      throw Exception('Fail to load');
    }
  }

  @override
  Future<CambiarPesoDto> cambiarPeso(CambiarPesoDto cambiarPesoDto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    String url = '$urlKDS/cambiarPeso';
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: cambiarPesoDto.toJson());

    if (response.statusCode == 200) {
      return cambiarPesoDto;
    } else {
      throw Exception('Fail to load');
    }
  }
}
