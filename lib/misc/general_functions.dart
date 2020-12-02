import 'package:marca_horario/model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

//function to sort the dataList by dateTime
void sortDataListByDateTime(List<Data> dataList){
  dataList.sort((a,b) => DateTime.parse(convertDateTimeString(a.dateTime)).compareTo(DateTime.parse(convertDateTimeString(b.dateTime))));
}

//convert dateTime string from the BR format to a string standard dateTime able to be parsed as datetime. It's output allows to be parsed correctly.
String convertDateTimeString(String beforeString){
  var arraySplit = beforeString.split(' ');//gives dom, 29 de nov de 2020 14:19 for example
  String day = arraySplit[1];
  if(int.parse(day) >= 1 && int.parse(day) <= 9){ day = "0" + arraySplit[1];}else{day = arraySplit[1];}
  String month;
  String year = arraySplit[5];
  String time = arraySplit[6];
  if(arraySplit[3] == 'jan'){month = "01";}
  if(arraySplit[3] == 'fev'){month = "02";}
  if(arraySplit[3] == 'mar'){month = "03";}
  if(arraySplit[3] == 'abr'){month = "04";}
  if(arraySplit[3] == 'mai'){month = "05";}
  if(arraySplit[3] == 'jun'){month = "06";}
  if(arraySplit[3] == 'jul'){month = "07";}
  if(arraySplit[3] == 'ago'){month = "08";}
  if(arraySplit[3] == 'set'){month = "09";}
  if(arraySplit[3] == 'out'){month = "10";}
  if(arraySplit[3] == 'nov'){month = "11";}
  if(arraySplit[3] == 'dez'){month = "12";}
  String afterString = year + '-' + month + '-' + day + ' ' + time;
  return afterString;//gives 2020-11-29 14:19 for example
}

void saveStringOnSharedPreferences(String keyString, String value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(keyString, value);
}

Future<String> recoverStringFromSharedPreferences(String keyString) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(keyString);
  return stringValue;
}

void removeStringFromSharedPreferences(String keyValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(keyValue);
}