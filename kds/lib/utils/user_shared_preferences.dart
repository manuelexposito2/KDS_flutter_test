import 'package:shared_preferences/shared_preferences.dart';

/*
Similar a LocalStorage en Web, SharedPreferences nos permite almacenar datos en la cache del dispositivo.
*/
class UserSharedPreferences {
  static late SharedPreferences _prefs;

//Para el resumen
  static Future<void> setResumeCall(String newResumeCall) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("resumeCall", newResumeCall);
  }

  static Future<String> getResumeCall() async {
    _prefs = await SharedPreferences.getInstance();
    final resumeCall = _prefs.getString("resumeCall");

    return resumeCall ?? '';
  }

  static Future<void> removeResumeCall() async {
    _prefs = await SharedPreferences.getInstance();

    _prefs.remove("resumeCall");
  }

//Para el temporizador de los detalles de las comandas
  static Future<void> setDetailTimer(String idDetail, int seconds) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setInt("timer_$idDetail", seconds);
  }

  static Future<int> getDetailTimer(String idDetail) async {
    _prefs = await SharedPreferences.getInstance();

    final getTime = _prefs.getInt("timer_$idDetail");

    return getTime ?? 0;
  }

  static Future<void> removeDetailTimer(String idDetail) async {
    _prefs = await SharedPreferences.getInstance();

    _prefs.remove("timer_$idDetail");
  }

//Para buscar la ultima linea de comanda seleccionada, especifica para el modo Solo_ultimo_plato

  static Future<String> getLastDetailSelected() async {
    _prefs = await SharedPreferences.getInstance();

    final lastSelected = _prefs.getString("lastDetailSelected");

    return lastSelected ?? '';
  }

  static Future<void> setLastDetailSelected(String idDetail) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("lastDetailSelected", idDetail);
  }

  static Future<void> removeLastDetailSelected() async {
    _prefs = await SharedPreferences.getInstance();

    _prefs.remove("lastDetailSelected");
  }

  //Buscar la URL del KDS para Web

  static Future<String?> getUrlKds() async {
    _prefs = await SharedPreferences.getInstance();

    final urlKds = _prefs.getString("urlKDS");

    return urlKds;
  }

  static Future<void> setUrlKds(String newUrl) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("urlKDS", newUrl);
  }

  static Future<void> removeUrlKds() async {
    _prefs = await SharedPreferences.getInstance();

    _prefs.remove("urlKDS");
  }
}
