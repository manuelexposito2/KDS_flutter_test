import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/repository/repository/status_detail_repository.dart';
import 'package:kds/utils/constants.dart';

class StatusDetailRepositoryImpl extends StatusDetailRepository {
  @override
  Future<DetailDto> statusDetail(DetailDto detailDto) async {
    String url = 'http://$apiBaseUrl:$puertoKDS/modifyDetailKDS';
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
}
