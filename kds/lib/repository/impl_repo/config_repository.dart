import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kds/models/status/config.dart';


import 'package:flutter/services.dart' show rootBundle;

class ConfigRepository {

  static Future<Config> readConfig() async {
    String file = await rootBundle.loadString('assets/files/numierKDS.ini');
    String urlBase = file.split("\n")[1].split("=")[1];

    final String url = "$urlBase/readConfig";

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return Config.fromJson(jsonDecode(request.body));
    } else {
      throw Exception("No pudo leerse el archivo numierKDS.ini");
    }

    // throw UnimplementedError();
  }
}
