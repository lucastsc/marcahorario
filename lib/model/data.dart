// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

List<Data> dataFromJson(String str) => List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
  String objectId;
  String dateTime;
  String employee;
  String companyName;

  Data({
    this.objectId,
    this.dateTime,
    this.employee,
    this.companyName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    objectId: json["objectId"],
    dateTime: json["dateTime"],
    employee: json["employee"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "objectId": objectId,
    "dateTime": dateTime,
    "employee": employee,
    "companyName": companyName,
  };
}