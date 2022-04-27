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
      String idOrder, ReadOptionsDto? dto) async {
    //final file = await _localFile;

    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = "$urlKDS/writeOpciones";
    //currentOptions.forEach((key, value) {print(value.runtimeType.toString());});
    
    //TODO: SOLUCIONAR [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: type 'int' is not a subtype of type 'String' in type cast
    Map<String, dynamic> currentOptions = {
      "idOrder" : dto?.idOrder,
      "opcion1" : dto?.opcion1,
      "opcion2" : dto?.opcion2,
      "opcion3" : dto?.opcion3,
      "opcion4" : dto?.opcion4,
      "opcion5" : dto?.opcion5,
      "opcion6" : dto?.opcion6,
      "opcion7" : dto?.opcion7,
      "opcion8" : dto?.opcion8
    };
    final response =
        await http.post(Uri.parse(url), body: currentOptions);

    if (response.statusCode == 200) {
      print(ReadOptionsDto.fromJson(jsonDecode(response.body)).toJson().toString());
      //return ReadOptionsDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fail to load');
    }
  }
}
