

import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../api/TestDio.dart';
import '../models/generate_url_response.dart';

class AssetsProvider extends ChangeNotifier {

  Future<GenerateUrlResponse2?> generateUrl(String fileName, String fileExtension, String type) async{
    final data = {
      "name": fileName,
      "extension": fileExtension,
      "type": type
    };
    try {
      final Response response = await TestApi.post('https://metafans-backend-2pg2o.ondigitalocean.app/generateURL', data);
      print(response.data);
      final resp = GenerateUrlResponse2.fromJson(response.data);
      return resp;
    } on DioError catch (e) {
      print("imprimiendo e.error: ${e.error}");
      print("imprimiendo e.message: ${e.message}");
      return null;
    }
  }

  Future insertAssetAudio(Uint8List bytes, String path) async {
    TestApi.putForAssetAudio(path, bytes).then((value) {
      if(value == null) {
        print('no se subio');
      } else {
        print("se subio el archivo");
      }
    });
  }
}