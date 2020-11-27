import 'dart:convert';

import 'package:http/http.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/constants.dart';

class DataUtils {

  //static final String _baseUrl = "https://parseapi.back4app.com/classes/";
  static final String _baseUrl = baseUrl;

  //CREATE
  static Future<Response> addData(Data data, String classNameDB) async {
    //String apiUrl = _baseUrl + "Data";
    String apiUrl = _baseUrl + classNameDB;

    Response response = await post(apiUrl,
      headers: {
        'X-Parse-Application-Id': kParseApplicationId,
        'X-Parse-REST-API-Key': kParseRestApiKey,
        'Content-Type': 'application/json'
      },
      body: json.encode(data.toJson()),
    );

    return response;
  }

  //READ
  static Future getDataList(String classNameDB) async{

    //String apiUrl = _baseUrl + "Data";
    String apiUrl = _baseUrl + classNameDB;

    Response response = await get(apiUrl, headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    return response;
  }

  //UPDATE
  static Future updateData(Data data, String classNameDB) async{

    //String apiUrl = _baseUrl + "Data/${data.objectId}";
    String apiUrl = _baseUrl + "$classNameDB/${data.objectId}";

    Response response = await put(apiUrl, headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
      'Content-Type' : 'application/json',
    },
        body: json.encode(data.toJson())
    );

    return response;
  }

  //DELETE
  static Future deleteData(String objectId, String classNameDB) async{

    //String apiUrl = _baseUrl + "Data/$objectId";
    String apiUrl = _baseUrl + "$classNameDB/$objectId";

    Response response = await delete(apiUrl, headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    return response;
  }
}