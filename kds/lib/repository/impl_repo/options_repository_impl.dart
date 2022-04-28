import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kds/models/status/read_options_dto.dart';

import 'package:http/http.dart' as http;
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/options_repository.dart';
import 'package:path_provider/path_provider.dart';

class OptionsRepositoryImpl implements OptionsRepository {
  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/x-www-form-urlencoded",
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
  Future<void> writeOpciones( ReadOptionsDto dto) async {
    

    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = "$urlKDS/writeOpciones";
    
    //TODO: SOLUCIONAR [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: type 'int' is not a subtype of type 'String' in type cast

   // print("DTO --> ${dto.toJson()}");
   // print("MAP --> ${currentOptions}");
    dto.toJson().forEach((key, value) {
      print("$key --> ${value.runtimeType}" );
    });
    //print(dto.toJson());
    debugPrint(ReadOptionsDto.fromJson(jsonDecode(dto.toJson().toString())).toString());

   
    debugPrint(jsonEncode(dto.toJson()));
    //print(jsonDecode(currentOptions.toString()));
    final response =
        await http.post(Uri.parse(url), headers:headers, body: jsonEncode(dto.toJson()));
    
    if (response.statusCode == 200) {
      print("SUCCESS");
      //print(ReadOptionsDto.fromJson(jsonDecode(response.body)).toJson().toString());
      //return ReadOptionsDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode} : ${response.body}");
    }
  }
}
