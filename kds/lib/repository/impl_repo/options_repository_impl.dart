import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kds/models/status/read_options_dto.dart';

import 'package:http/http.dart' as http;
import 'package:kds/models/write_options_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/options_repository.dart';
import 'package:path_provider/path_provider.dart';
import './../../utils/string_extension.dart';

class OptionsRepositoryImpl implements OptionsRepository {
  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    //"Content-Type": "application/x-www-form-urlencoded",
    "Content-Type": "application/json",
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

  //TODO: Arreglar esta petición
  @override
  Future<void> writeOpciones(ReadOptionsDto dto) async {
    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = "$urlKDS/writeOpciones";

    WriteOptionsDto writeOptions = WriteOptionsDto(
        data: Data(
            idOrder: dto.idOrder,
            opcion1: dto.opcion1,
            opcion2: dto.opcion2,
            opcion3: dto.opcion3,
            opcion4: dto.opcion4,
            opcion5: dto.opcion5,
            opcion6: dto.opcion6,
            opcion7: dto.opcion7,
            opcion8: dto.opcion8));

  
    print(jsonEncode(writeOptions));
    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(writeOptions));

    if (response.statusCode == 200) {
      print("SUCCESS");
    } else {
      throw Exception("${response.statusCode} : ${response.body}");
    }
  }
}

