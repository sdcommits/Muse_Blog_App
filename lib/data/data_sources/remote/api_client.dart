import 'dart:developer';

import 'package:bogging_app/data/data_sources/remote/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import 'api_constant.dart';
import 'api_endpoint_urls.dart';
//
class ApiClient {
  late Dio dio;
  late BaseOptions baseOptions;

  ApiClient() {
    baseOptions = BaseOptions(baseUrl: ApiConstant.mainUrl);
    dio = Dio(baseOptions);
  }
  Options options  = Options();
  //Get request
  Future<Response> getRequest({required String path,  bool isTokenRequired = false}) async {

    if(isTokenRequired == true){
      var token = await Utils.getToken();
      options.headers = baseOptions.headers..addAll({"Authorization": "Bearer $token"});

    }


    
    // final options = BaseOptions(baseUrl: ApiConstant.mainUrl);
    //
    // final dio = Dio(options);


    try {
      debugPrint("🚀=========API REQUEST============🚀");
      debugPrint("Request Url: ${baseOptions.baseUrl + path}");
      var response = await dio.get(path, options: options);
      debugPrint("🔥=========API RESPONSE============🔥");
      debugPrint("Status Code : ${response.statusCode}");
      log("DATA : ${response.data.toString().substring(0,300)}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        throw ApiException(message: e.response!.statusMessage);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message);
      }
    }
  }

  Future<Response> postRequest({required String path, dynamic body}) async {
    var token = await Utils.getToken();
    final options = Options(
      headers: {"Authorization" :
      "Bearer $token"},
    );
    try {
      debugPrint("🚀=========API REQUEST============🚀");
      debugPrint("Request Url: ${baseOptions.baseUrl + path}");
      debugPrint("Body : $body");
      var response = await dio.post(path, data : body, options: options);
      debugPrint("🔥=========API RESPONSE============🔥");
      debugPrint("Status Code : ${response.statusCode}");
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        throw ApiException(message: e.response!.statusMessage);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message);
      }
    }
  }
}

//
// class ApiClient {
//   late Dio dio;
//   late BaseOptions baseOptions;
//
//   ApiClient() {
//     baseOptions = BaseOptions(baseUrl: ApiConstant.mainUrl);
//     dio = Dio(baseOptions);
//   }
//
//   Options options = Options();
//
//   /// GET REQUEST
//   Future<Response> getRequest(
//       {required String path, bool isTokenRequired = false}) async {
//     if (isTokenRequired == true) {
//       var token = await Utils.getToken();
//       options.headers = baseOptions.headers
//         ..addAll({"Authorization": "Bearer $token"});
//     }
//     try {
//       debugPrint("🚀============API REQUEST============🚀");
//       debugPrint("Request Url: ${baseOptions.baseUrl + path}");
//       var response = await dio.get(path, options: options);
//       debugPrint("🔥============API RESPONSE============🔥");
//       debugPrint("Status Code: ${response.statusCode}");
//       log("DATA: ${response.data.toString().substring(0, 300)}");
//       return response;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         debugPrint(e.response!.data.toString());
//         debugPrint(e.response!.headers.toString());
//         debugPrint(e.response!.requestOptions.toString());
//         throw ApiException(message: e.response!.statusMessage);
//       } else {
//         // Something happened in setting up or sending the request that triggered an Error
//         debugPrint(e.requestOptions.toString());
//         debugPrint(e.message);
//         throw ApiException(message: e.message);
//       }
//     }
//   }
//
//   /// POST REQUEST
//   Future<Response> postRequest(
//       {required String path,
//         dynamic body,
//         bool isTokenRequired = false}) async {
//     if (isTokenRequired == true) {
//       var token = await Utils.getToken();
//       options.headers = baseOptions.headers
//         ..addAll({"Authorization": "Bearer $token"});
//     }
//
//     try {
//       debugPrint("🚀============API REQUEST============🚀");
//       debugPrint("Request Url: ${baseOptions.baseUrl + path}");
//       debugPrint("Body: $body");
//       var response = await dio.post(path, data: body, options: options);
//       debugPrint("🔥============API RESPONSE============🔥");
//       debugPrint("Status Code: ${response.statusCode}");
//       log("DATA: ${response.data}");
//       return response;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         debugPrint(e.response!.data.toString());
//         debugPrint(e.response!.headers.toString());
//         debugPrint(e.response!.requestOptions.toString());
//         throw ApiException(message: e.response!.statusMessage);
//       } else {
//         // Something happened in setting up or sending the request that triggered an Error
//         debugPrint(e.requestOptions.toString());
//         debugPrint(e.message);
//         throw ApiException(message: e.message);
//       }
//     }
//   }
// }
