import 'dart:convert';
import 'package:base_app/config/app_config.dart';
import 'package:base_app/model/auth_user_entity.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/util/request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Request {
  late Dio dio;
  late BuildContext context;
  // 初始化
  Request(this.context) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.serverUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      contentType: "multipart/form-data",
      responseType: ResponseType.plain,
    ));
    setInterceptor();
  }
  setInterceptor() {
    dio.interceptors.add(LogInterceptor(requestBody: true,responseBody: true));
    dio.interceptors.add(InterceptorsWrapper(
      // 在请求被发送之前做一些事情
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        //判断用户是否登陆
        AuthUserEntity authUserEntity = Provider.of<AuthProvider>(context,listen: false).authUserEntity;
        options.headers["Authorization"] = authUserEntity.token??"";

        Logger().d("request hgeader" + jsonEncode(options.headers));
        return handler.next(options);
      },

      // 在返回响应数据之前做一些预处理
      onResponse: (Response response, ResponseInterceptorHandler handler) async {
        ResponseModel model = ResponseModel.fromJson(jsonDecode(response.data));
        if(model.code !=1){
          toast(model.msg);
        }
        return handler.next(response);
      },

      // 当请求失败时做一些预处理
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        EasyLoading.dismiss();
        if(e.type == DioErrorType.connectTimeout ){
          return handler.next(e);
        }
        if(e.response?.data != null){
          Fluttertoast.showToast(
            backgroundColor: Colors.black45,
            msg:  e.response!.data.containsKey('msg') ? e.response!.data['msg'] : "",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            textColor: Colors.white,
            fontSize: 12,
          );
          return handler.next(e);
        }
        else{
          Fluttertoast.showToast(
            backgroundColor: Colors.black45,
            msg:  e.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            textColor: Colors.white,
            fontSize: 12,
          );
          return handler.next(e);
        }
      },
    ),);
  }

  // post 请求
  Future<ResponseModel> post<T>(String url, {data, cancelToken}) async {
    Response<String> response = await dio.post(
      url,
      data: data,
      cancelToken: cancelToken,
    );
    Map<String, dynamic> res =  jsonDecode(response.data??"{'code':400,'message':'服务器返回空数据'}");
    ResponseModel<T> result = ResponseModel.fromJson(res);
    return result;
  }

  // get 请求
  Future<ResponseModel> get(String url, {data, cancelToken}) async {
    Response<String> response = await dio.get(
        url,
        queryParameters: data,
        cancelToken: cancelToken,
    );

    Map<String, dynamic> res =  jsonDecode(response.data??"{'code':400,'message':'服务器返回空数据'}");
    ResponseModel result = ResponseModel.fromJson(res);

    return result;
  }


  // get 请求
  Future<Response> map(String url, {data, cancelToken}) async {
    Response response = await dio.get(
      url,
      queryParameters: data,
      cancelToken: cancelToken,
    );
    return response;
  }

  static toast(String message){
    Fluttertoast.showToast(
      backgroundColor: const Color(0xffFF844B),
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}






