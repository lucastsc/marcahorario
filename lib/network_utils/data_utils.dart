import 'dart:convert';

import 'package:http/http.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/constants.dart';

class DataUtils {

  static final String _baseUrl = "https://parseapi.back4app.com/classes/";

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
}