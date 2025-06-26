import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import '../utils/UtilityClass.dart';

class HttpService {
  late Dio _dio;
  // , "Authorization" : "Bearer ${StaticVariables.authToken}"
  HttpService(BuildContext context, String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      //  headers: {"Content-Type": "application/json", "Authorization" : "Bearer ${StaticVariables.authToken}"},
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(milliseconds: 15000),
    ));

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    initializeInterceptors(context);
  }

  Future<Response> getRequest(String endPoint) async{
    debugPrint("Call Started!");
    Response response;

    try {
      response = await _dio.get(endPoint);
      debugPrint(response.data.toString());
    } on DioError catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }

    return response;

  }

  Future<Response> postRequest(String endpoint, dynamic param) async{
    debugPrint("Call Started!");
    Response response;
    try {
      response = await _dio.post(endpoint, data: json.encode(param));
    } on DioError catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return response;

  }

  Future<Response> MultipartFilePostRequest(String endpoint, FormData formData) async{
    debugPrint("Call Started!, FormData formData");
     Options options = Options(headers: {'Content-Type': 'multipart/form-data',},);
    Response response;
    try {
      response = await _dio.post(endpoint, data: formData,options:options);
    } on DioError catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return response;

  }


  Future<Response> ssoRequest(String baseUrl, String endpoint, dynamic param) async{
    debugPrint("Call Started!");
    Response response;
    try {
      response = await _dio.post(baseUrl+endpoint, data: param, options: Options(
        // baseUrl: baseurl,
        headers: {"Content-Type": "RS/x-www-form-urlencoded"},
      ));
    } on DioError catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return response;

  }

  initializeInterceptors(BuildContext context) {
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (error, handler){
          debugPrint('onError: ${error.message}');
          UtilityClass.dismissProgressDialog();
          if(error.response?.statusCode == 401) {
            UtilityClass.askForInput('Alert', 'You are not authorized.', 'Okay', 'Okay', true);
          } else {
            UtilityClass.askForInput( 'Alert', 'Some issue occurred while connecting with server. Please try again.', 'Okay', 'Okay', true);
          }
          return handler.reject(error); //.next(error);
        },
        onRequest: (request, handler){
          debugPrint("onRequest: ${request.method} ${request.path}");
          UtilityClass.showProgressDialog(context, 'Please wait...');
          return handler.next(request);
        },
        onResponse: (response, handler){
          debugPrint('onResponse: ${response.data.toString()}');
          UtilityClass.dismissProgressDialog();
          return handler.next(response);
        }
    ));
  }
}