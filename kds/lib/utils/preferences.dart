
import 'package:kds/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences{

  static late SharedPreferences _prefs;

   static Future<void> setQueryParam(String filter) async{

    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString(queryParam, filter);

  }

  static Future<String?> getQueryParam() async{
    _prefs = await SharedPreferences.getInstance();
    final filter = _prefs.getString(queryParam);
    
    return  filter ?? '';
  }

}