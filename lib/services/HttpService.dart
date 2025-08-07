import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/UtilityClass.dart';

class HttpService {
  late Dio _dio;
  // , "Authorization" : "Bearer ${StaticVariables.authToken}"
  HttpService(String baseUrl,BuildContext context) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 15),
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

  // Future<Response> postRequest(String endpoint, dynamic param) async{
  //   debugPrint("Call Started!");
  //   Response response;
  //   try {
  //     response = await _dio.post(endpoint, data: json.encode(param));
  //   } on DioError catch (e) {
  //     debugPrint(e.message);
  //     throw Exception(e.message);
  //   }
  //   return response;
  //
  // }

  Future<Response> postRequest(String endpoint, dynamic param) async {
    debugPrint("Call Started!");
    debugPrint("URL: ${_dio.options.baseUrl}$endpoint");
    debugPrint("Data: ${json.encode(param)}");

    try {
      final response = await _dio.post(
        endpoint,
        data: json.encode(param),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint("Response: ${response.data}");
      return response;
    } on DioError catch (e) {
      debugPrint("❌ DioError occurred!");
      debugPrint("Type: ${e.type}");
      debugPrint("Message: ${e.message}");
      debugPrint("Error: ${e.error}");
      debugPrint("URI: ${e.requestOptions.uri}");
      debugPrint("Headers: ${e.requestOptions.headers}");
      debugPrint("Data: ${e.requestOptions.data}");
      debugPrint("Response: ${e.response}");
      throw Exception("Dio error: ${e.message}");
    }
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
      onError: (error, handler) {
        debugPrint('onError: ${error.message}');
        return handler.reject(error);
      },
      onRequest: (request, handler) {
        UtilityClass.showProgressDialog(navigatorKey.currentState!.context,'Please wait...');
        debugPrint("onRequest: ${request.method} ${request.path}");
        return handler.next(request);
      },
      onResponse: (response, handler) {
        debugPrint('onResponse: ${response.data.toString()}');
        UtilityClass.dismissProgressDialog();
        return handler.next(response);
      },
    ));
  }

}