// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _listTiles = List<String>();
  Color _iconColor = Colors.black;
  Color standardIconColor = Colors.black;
  Color alternateIconColor = Colors.green;
  TextEditingController _nameController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String standardTileTitle = "Adicione um horário disponível...";
  String _titleTile = "Adicione um horário disponível...";
  String _tileSubtitle = "Edite o nome do funcionário...";
  int _selectedIndexBottomNavBar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                minTime: DateTime(2020, 1, 1),
                maxTime: DateTime(2021, 12, 31),
                onChanged: (date) {
                  print('change $date');
                },
                onConfirm: (date) {
                  print('confirm $date');
                  _listTiles.add(DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString());
                  _titleTile = DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString();

                  setState(() {

                  });
                },
                currentTime: DateTime.now(),
                locale: LocaleType.pt);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: bottomNavigationBar(),
        appBar: AppBar(
          title: Text('Marca Horário'),
        ),
        // body: Center(
        //   child: Text('Hello World'),
        body: bodyStartScreen()
    );
  }

  Widget bottomNavigationBar(){

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndexBottomNavBar = index;
      });
      print(_selectedIndexBottomNavBar);
      if(_selectedIndexBottomNavBar == 2){
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: DateTime(2020, 1, 1),
            maxTime: DateTime(2021, 12, 31),
            onChanged: (date) {
              print('change $date');
            },
            onConfirm: (date) {
              print('confirm $date');
              _listTiles.add(DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString());
              _titleTile = DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString();

              setState(() {

              });
            },
            currentTime: DateTime.now(),
            locale: LocaleType.pt);
      }
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Funcionário',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Marcar',
        ),
      ],
      currentIndex: _selectedIndexBottomNavBar,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }



  Widget bodyStartScreen(){
    return Column(
      children: [
        //the main title of the screen
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Horários Possíveis",
            style: TextStyle(
                fontSize: 18.0
            ),
          ),
        ),
        //gets available employees and datetimes from the server
        FutureBuilder(builder: (context,snapshot){
          if (snapshot.data != null) {
            List<Data> dataList = snapshot.data;

            return Expanded(
              child: ListView.builder(itemBuilder: (_, position) {
                return Card(
                  child: ListTile(
                    title: Text(dataList[position].dateTime),
                    subtitle: Text(dataList[position].employee),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.edit), onPressed: () {
                          //Show dialog box to update item
                          //showUpdateDialog(dataList[position]);
                          //enterEmployeeAvailable(position);
                        }),
                        IconButton(icon: Icon(Icons.check_circle, color: Colors.green,), onPressed: () {
                          //Show dialog box to delete item
                          //deleteTodo(todoList[position].objectId);
                        }),
                        IconButton(icon: Icon(Icons.delete), onPressed: () {
                          //Show dialog box to update item
                          //showUpdateDialog(dataList[position]);
                          //enterEmployeeAvailable(position);
                          deleteData(dataList[position].objectId);
                        }),
                      ],
                    ),
                  ),
                );
              },
                itemCount: dataList.length,
              ),
            );

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
          future: getDataList(),
        ),
        scheduleTile()
      ],
    );
  }

  Widget scheduleTile(){
    return Padding(
      padding: EdgeInsets.only(bottom: 80.0),
      child: Card(
        color: Colors.grey,
        child: ListTile(
          title: Text(_titleTile),
          subtitle: Text(_tileSubtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: standardIconColor,
                  size: 20.0,
                ),
                onPressed: () {
                  setState(() {
                    employeeAvailable();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: _iconColor,
                  size: 20.0,
                ),
                onPressed: () {
                  setState(() {
                    (_titleTile != standardTileTitle) ? confirmSchedule() : fillTimeDialog();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void fillTimeDialog(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Text("Insira o horário disponível!"),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("OK")),
          ],
        )
    );
  }

  void employeeAvailable(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Funcionário",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {

              Navigator.pop(context);
              //addTodo();
              setState(() {
                _tileSubtitle = "Disponível: " + _nameController.text;
              });

            }, child: Text("Inserir")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tileSubtitle = " ";
              });

            }, child: Text("Desfazer")),
          ],
        )
    );
  }

  void confirmSchedule(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Text("Confirma disponibilidade?")
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
              //addTodo();
              addData();
              setState(() {
                _iconColor = alternateIconColor;
                _tileSubtitle = "Disponível: " + _nameController.text;
              });

            }, child: Text("Confirma")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
              setState(() {
                _iconColor = standardIconColor;
                _tileSubtitle = " ";
              });

            }, child: Text("Não")),
          ],
        )
    );
  }

  void addData() {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      children: <Widget>[
        Text("Adicionando informações..."),
        CircularProgressIndicator(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
      duration: Duration(minutes: 1),
    ));

    Data data = Data(employee: _tileSubtitle, dateTime: _titleTile);

    DataUtils.addData(data)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 201) {
        //Successful
        _nameController.text = "";

        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Informações disponibilizadas!"), duration: Duration(seconds: 1),));

        setState(() {
          //Update UI
        });

      }

    });

  }

  void deleteData(String objectId) {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  <Widget>[
        Text("Excluindo disponibilidade..."),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    DataUtils.deleteData(objectId)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: (Text("Disponibilidade excluída!")),duration: Duration(seconds: 1),));
        setState(() {

        });
      } else {
        //Handle error
      }
    });

  }

  Future <List<Data>> getDataList() async{

    List<Data> todoList = [];

    Response response = await DataUtils.getDataList();
    print("Code is ${response.statusCode}");
    print("Response is ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var results = body["results"];

      for (var todo in results) {
        todoList.add(Data.fromJson(todo));
      }

    } else {
      //Handle error
    }

    return todoList;
  }
}




