import 'dart:convert';

import 'package:base_app/model/auth_user_entity.dart';
import 'package:base_app/model/company_entity.dart';
import 'package:base_app/model/index_entity.dart';
import 'package:base_app/model/performance_form.dart';
import 'package:base_app/model/preventive_form.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/util/request.dart';
import 'package:base_app/util/request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;


class Api {
  static Future<bool> login(BuildContext context,String username,String password) async{
    ResponseModel response = await Request(context).post("/user/login",data: FormData.fromMap({"user_login":username,"user_pass":password}));

    if(response.code !=1) return false;
    AuthUserEntity authUserEntity =  AuthUserEntity.fromJson(response.data);
    authUserEntity.name = username;
    Provider.of<AuthProvider>(context,listen: false).authUserEntity = authUserEntity;
    return true;
  }
  static Future<List<IndexSelect>> index(BuildContext context) async{
    ResponseModel response = await Request(context).get("/index/index");
    if(response.code !=1) return [];
    List<IndexSelect> list =  response.data.map<IndexSelect>((e)=>IndexSelect.fromJson(e)).toList();
    return list;
  }

  static Future<Company?> company(BuildContext context) async{
    List<IndexSelect> select = await index(context);
    ResponseModel response = await Request(context).get("/user/top");
    if(response.code !=1) return null;
    Company company =  Company.fromJson(response.data);
    company.indexSelect = select;
    return company;
  }

  static Future<List<PerformanceForm>?> performanceForm(BuildContext context,int cid) async{
    ResponseModel response = await Request(context).post("/performance/index",data: FormData.fromMap({"cid":cid}));
    if(response.code !=1) return null;
    List<PerformanceForm> list =  response.data.map<PerformanceForm>((e)=>PerformanceForm.fromJson(e)).toList();
    return list;
  }

  static Future<PreventiveForm?> preventiveForm(BuildContext context,int cid) async{
    ResponseModel response = await Request(context).post("/preventive/index",data: FormData.fromMap({"cid":cid}));
    if(response.code !=1) return null;
    return PreventiveForm.fromJson(response.data);
  }

  static Future<bool?> performanceSubmit(BuildContext context,List<PerformanceForm> performance,int cid,Map<String,dynamic> extra,String plant) async{
    Map<String,dynamic> params = {"json":performance,"cid":cid,"extra":extra,"plant":plant};
    developer.log(jsonEncode(params), name: 'my.other.category');
    ResponseModel response = await Request(context).post("/performance/submit",data:params);
    return response.code ==1;
  }
}