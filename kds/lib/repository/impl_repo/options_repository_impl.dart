
import 'dart:convert';
import 'dart:io';

import 'package:kds/models/status/read_options_dto.dart';

import 'package:http/http.dart' as http;
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/repository/repository/options_repository.dart';
import 'package:path_provider/path_provider.dart';

class OptionsRepositoryImpl implements OptionsRepository{

  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/x-www-form-urlencoded"
  };


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
  

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/opciones');
  }

@override
  Future<void> writeOpciones(String idOrder) async {
    final file = await _localFile;
    
    String urlKDS = await ConfigRepository.getUrlKDS();

    String url = "$urlKDS/writeOpciones";

    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
          //__$idOrder.json
      file.writeAsString("");

    } else {
      throw Exception('Fail to load');
    }
  }
}
