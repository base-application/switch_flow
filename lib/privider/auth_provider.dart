
import 'dart:convert';

import 'package:base_app/model/auth_user_entity.dart';
import 'package:base_app/util/cache_util.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{

  AuthUserEntity _authUserEntity = AuthUserEntity();

  AuthProvider(){
    if(CacheUtil.get(CacheKey.auth.name).isNotEmpty){
      _authUserEntity = AuthUserEntity.fromJson(jsonDecode(CacheUtil.get(CacheKey.auth.name)));
    }
  }

  AuthUserEntity get authUserEntity {
    return _authUserEntity;
  }

  set authUserEntity(AuthUserEntity value) {
    _authUserEntity = value;
//    CacheUtil.save(CacheKey.auth.name, jsonEncode(value));
    notifyListeners();
  }
}