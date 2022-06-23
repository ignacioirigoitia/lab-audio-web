import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';


class TestApi{
  static Dio _dio = new Dio();

  static Future post(String path, dynamic data) async {
    try {
      final resp = await _dio.post(path, data: data);
      return resp;
    } on DioError catch (e) {
      print('imprimiendo en el error del post: ${e.message}');
      return e.response;
    }
  }

  static Future putForAsset(String path, dynamic data, String pathFile) async {
    Uint8List image = data;
    print('pathFile: $pathFile');
    print(lookupMimeType(pathFile));
    Options options = Options(
      contentType: lookupMimeType(pathFile),
      headers: {
        'Accept': "*/*",
        'Content-Length': image.length,
        'Connection': 'keep-alive',
        'User-Agent': 'ClinicPlush',
        'x-amz-acl': 'public-read'
      }
    );
    Response resp;
    try {
      resp = await _dio.put(path, data: Stream.fromIterable(image.map((e) => [e])), options: options);
      return resp;
    } on DioError catch (e) {
      print("imprimiendo en el error del put del asset: ${e.message}");
    }
  }

  static Future putForAssetAudio(String path, dynamic data) async {
    Uint8List image = data;
    Options options = Options(
      contentType: 'audio/m4a',
      headers: {
        'Accept': "*/*",
        'Content-Length': image.length,
        'Connection': 'keep-alive',
        'User-Agent': 'ClinicPlush',
        'x-amz-acl': 'public-read'
        // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
        // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        // "Access-Control-Allow-Methods": "POST, PUT"
      }
    );
    print(image);
    Response resp;
    try {
      resp = await _dio.put(path, data: Stream.fromIterable(image.map((e) => [e])), options: options);
      return resp;
    } on DioError catch (e) { 
      print("imprimiendo en el error del put del asset: ${e.message}");
    }
  }
}