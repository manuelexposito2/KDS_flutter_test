import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kds/models/status/config.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ConfigRepository {
  static Future<String> getUrlKDS() async {
    /* String urlKds = await rootBundle.loadString(numierKDSUrl);
    //print(urlKds);
    //return file.split("\n")[1].split("=")[1];

    var result = urlKds.contains("http://") ? urlKds : "http://$urlKds";
    return result; */

    return 'http://192.168.1.42:82';
  }

  static Future<Config> readConfig() async {
    String urlBase = await getUrlKDS();

    final String url = "$urlBase/readConfig";

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      //debugPrint(Config.fromJson(jsonDecode(request.body)).toJson().toString());
      return Config.fromJson(jsonDecode(request.body));
    } else {
      throw Exception("No pudo leerse el archivo numierKDS.ini");
    }

    // throw UnimplementedError();
  }
}
