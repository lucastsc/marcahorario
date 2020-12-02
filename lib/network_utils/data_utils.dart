import 'dart:convert';

import 'package:http/http.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/constants.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DataUtils {

  //static final String _baseUrl = "https://parseapi.back4app.com/classes/";
  static final String _baseUrl = baseUrl;

  //CREATE
  static Future<Response> addData(Data data) async {
    String apiUrl = _baseUrl + "Data";

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
  // static Future getDataList(String classNameDB) async{
  //
  //   //String apiUrl = _baseUrl + "Data";
  //   String apiUrl = _baseUrl + classNameDB;
  //
  //   Response response = await get(apiUrl, headers: {
  //     'X-Parse-Application-Id' : kParseApplicationId,
  //     'X-Parse-REST-API-Key' : kParseRestApiKey,
  //   });
  //
  //   return response;
  // }

  //Using exclusively parse library for getting data from "Data" class in the Parse Server
  static Future getDataList(String colname, String classNameDB) async{

    QueryBuilder<ParseObject> queryColname =
    QueryBuilder<ParseObject>(ParseObject("Data"))
      ..whereEqualTo(colname, classNameDB);

    ParseResponse apiResponse = await queryColname.query();

    return apiResponse;
  }

  //Using exclusively parse library for getting user from "User" class in the Parse Server
  static Future getUser(String colname, String name) async{

    QueryBuilder<ParseObject> queryColname =
    QueryBuilder<ParseObject>(ParseObject("_User"))
      ..whereEqualTo(colname, name);

    ParseResponse apiResponse = await queryColname.query();

    return apiResponse;
  }

  //UPDATE
  static Future updateData(Data data) async{

    String apiUrl = _baseUrl + "Data/${data.objectId}";

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

    String apiUrl = _baseUrl + "Data/$objectId";
    //String apiUrl = _baseUrl + "$classNameDB/$objectId";

    Response response = await delete(apiUrl, headers: {
      'X-Parse-Application-Id' : kParseApplicationId,
      'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    return response;
  }

  //Checks in the "Data" class if the specified username is present in the colName.It returns how many of it.
  static Future verifyClientAlreadyScheduled(String colName, String username) async{
    QueryBuilder<ParseObject> queryUserName =
    QueryBuilder<ParseObject>(ParseObject("Data"))
      ..whereEqualTo(colName, username);

    ParseResponse apiResponse = await queryUserName.query();
    return apiResponse.count;
  }

  //Checks in the "Data" class if the specified companyName is present.If it is present, returns true.
  static Future verifyCompanyExists(String colName, String companyName) async{
    QueryBuilder<ParseObject> queryCompanyName =
    QueryBuilder<ParseObject>(ParseObject("Data"))
      ..whereEqualTo(colName, companyName);

    ParseResponse apiResponse = await queryCompanyName.query();
    bool exists = apiResponse.count >= 1 ? true : false;
    return exists;
  }

  //Checks in the "_User" class if the specified name is a company.If so, returns true
  static Future verifyUserIsCompany(String companyName) async{
    QueryBuilder<ParseObject> queryCompanyName =
    QueryBuilder<ParseObject>(ParseObject("_User"))
      ..whereEqualTo("username", companyName)
      ..whereEqualTo("isCompany", true);

    ParseResponse apiResponse = await queryCompanyName.query();
    bool exists = apiResponse.count != 0 ? true : false;
    return exists;
  }



}