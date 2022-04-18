import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kds/models/status/config.dart';

import 'package:flutter/services.dart' show rootBundle;

class ConfigRepository {
  static Future<String> getUrlKDS() async {
    String file = await rootBundle.loadString('assets/files/numierKDS.ini');
    return file.split("\n")[1].split("=")[1];
  }

  static Future<Config> readConfig() async {
    
    String urlBase = await getUrlKDS();

    final String url = "$urlBase/readConfig";

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      debugPrint(Config.fromJson(jsonDecode(request.body)).toJson().toString());
      return Config.fromJson(jsonDecode(request.body));
    } else {
      throw Exception("No pudo leerse el archivo numierKDS.ini");
    }

    // throw UnimplementedError();
  }
}
