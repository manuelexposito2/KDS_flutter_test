import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kds/models/status/config.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:kds/utils/user_shared_preferences.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConfigRepository {
  static var numierKDSUrl = 'assets/files/numierKDS.ini';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/numierKDS.ini');
  }

  static Future<String> getUrlKDS() async {
    try {
      if (kIsWeb) {
        String urlKds =
            await rootBundle.loadString('assets/files/numierKDS.ini');

        return await UserSharedPreferences.getUrlKds() ?? "http://$urlKds";
      } else {
        final file = await _localFile;
        String urlKds = await file.readAsString();
        var result = urlKds.contains("http://") ? urlKds : "http://$urlKds";
        return result;
      }
    } catch (e) {
      return "";
    }
  }

  static Future<File> writeNewUrl(String newUrl) async {
    if (kIsWeb) {
      var result = newUrl.contains("http://") ? newUrl : "http://$newUrl";
      await UserSharedPreferences.setUrlKds(result);
      return File("");
    } else {
      final path = await _localPath;
      try {
        final file = await _localFile;

        return file.writeAsString('$newUrl');
      } catch (e) {
        //Si no encuentra el archivo
        var file = File('$path/numierKDS.ini');
        return file.writeAsString('$newUrl');
      }
    }
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
