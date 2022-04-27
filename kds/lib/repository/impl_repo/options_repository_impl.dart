import 'dart:convert';

import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/read_options_dto.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/options_repository.dart';
import 'package:http/http.dart' as http;

class OptionsRepositoryImpl implements OptionsRepository{

  @override
  Future<ReadOptionsDto> readOpciones(String id) async {
    String urlKDS = await ConfigRepository.getUrlKDS();
    String url = '$urlKDS/readOpciones?idOrder=$id';
    final request = await http.get(Uri.parse(url));
 

    if(request.statusCode == 200){
      return ReadOptionsDto.fromJson(jsonDecode(request.body));
    }else{
      throw Exception(request.statusCode);
    }

  }


}