import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kds/models/status/read_options_dto.dart';

import 'package:http/http.dart' as http;
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/options_repository.dart';
import 'package:path_provider/path_provider.dart';

class OptionsRepositoryImpl implements OptionsRepository {
  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  @override
  Future<ReadOptionsDto?> readOpciones(String id) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    String url = '$urlKDS/readOpciones?idOrder=$id';
    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return ReadOptionsDto.fromJson(jsonDecode(request.body));
    } else {
      throw Exception(request.statusCode);
    }
  }

  @override
  Future<void> writeOpciones(
      String idOrder, Map<String, dynamic> currentOptions) async {
    //final file = await _localFile;

    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = "$urlKDS/writeOpciones";
    //currentOptions.forEach((key, value) {print(value.runtimeType.toString());});

    final response =
        await http.post(Uri.parse(url), headers: headers, body: currentOptions);

    if (response.statusCode == 200) {
      debugPrint(ReadOptionsDto.fromJson(jsonDecode(response.body)).toJson().toString());
      //return ReadOptionsDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load');
    }
  }
}
