import 'dart:convert';

import 'package:base_app/model/auth_user_entity.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CacheKey{
  auth
}

class CacheUtil{
  static SharedPreferences? _preferences;
  init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static void save(key, value){
    _preferences?.setString(key, value) ?? '';
  }
  static String get(key){
    return _preferences?.getString(key) ?? '';
  }

}
