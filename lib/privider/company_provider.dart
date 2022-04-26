import 'dart:convert';

import 'package:base_app/model/company_entity.dart';
import 'package:base_app/util/cache_util.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier{
  Company? _company;


  CompanyProvider(){
    print(CacheUtil.get(CacheKey.auth.name));
    if(CacheUtil.get(CacheKey.auth.name).isNotEmpty){
      _company = Company.fromJson(jsonDecode(CacheUtil.get(CacheKey.company.name)));
    }
  }

  Company? get company => _company;

  set company(Company? value) {
    _company = value;
    CacheUtil.save(CacheKey.company.name, jsonEncode(value));
    notifyListeners();
  }


}