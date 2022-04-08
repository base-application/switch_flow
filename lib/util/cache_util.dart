import 'package:shared_preferences/shared_preferences.dart';

enum CacheKey{
  auth,
  preventive,
  company,
}

class CacheUtil{
  static SharedPreferences? _preferences;
  init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static void save(key, String value){
    _preferences?.setString(key, value) ?? '';
  }
  static String get(key){
    return _preferences?.getString(key) ?? '';
  }
  static clear(){
    _preferences?.clear();
  }

  static remove(key){
    _preferences?.remove(key);
  }

}
