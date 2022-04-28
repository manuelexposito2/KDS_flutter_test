import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static late SharedPreferences _prefs;

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

  static Future<void> setDetailTimer(String idDetail, String timer) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("timer_$idDetail", timer);
  }

  static Future<String> getDetailTimer(String idDetail) async {
    _prefs = await SharedPreferences.getInstance();

    final getTime = _prefs.getString("timer_$idDetail");

    return getTime ?? '00:00:00';
  }

  static Future<void> removeDetailTimer(String idDetail) async {
    _prefs = await SharedPreferences.getInstance();

    _prefs.remove("timer_$idDetail");
  }
}
