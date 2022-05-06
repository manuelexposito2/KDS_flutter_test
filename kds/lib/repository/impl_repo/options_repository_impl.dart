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

    //TODO: SOLUCIONAR [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: type 'int' is not a subtype of type 'String' in type cast

    // print("DTO --> ${dto.toJson()}");
    // print("MAP --> ${currentOptions}");
    dto.toJson().forEach((key, value) {
      // print("$key --> ${value.runtimeType}" );
    });

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

    Map<String, dynamic> bodyDto = {
      "idOrder": dto.idOrder,
      "opcion1": dto.opcion1,
      "opcion2": dto.opcion2,
      "opcion3": dto.opcion3,
      "opcion4": dto.opcion4,
      "opcion5": dto.opcion5,
      "opcion6": dto.opcion6,
      "opcion7": dto.opcion7,
      "opcion8": dto.opcion8,
    };
    //print(jsonEncode(dto.toJson()));
    //print(jsonDecode(dto.toJson().toString()));
    //print(dto.toJson());
    //print(bodyDto.toString());
    //print('"${jsonEncode(dto.toJson())}"');
    print(bodyDto.toString());
  
    print(jsonEncode(writeOptions));
    var xbody = "{data: " + dto.toJson().toString() + "}";
    //var xbody = dto.toJson();

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(writeOptions));

    if (response.statusCode == 200) {
      print("SUCCESS");
    } else {
      throw Exception("${response.statusCode} : ${response.body}");
    }
  }
}

