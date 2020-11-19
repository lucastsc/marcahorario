// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _listTiles = List<String>();
  Color _iconColor = Colors.black;
  var _iconsColors = List<Color>();
  Color standardIconColor = Colors.black;
  Color alternateIconColor = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        home: Builder(
          builder: (context) =>
              Scaffold(
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
                          _iconsColors.add(standardIconColor);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.pt);
                  },
                  child: Icon(Icons.add),
                ),
                appBar: AppBar(
                  title: Text('Marca Horário'),
                ),
                // body: Center(
                //   child: Text('Hello World'),
                body: bodyStartScreen()
              ),
        )
    );
  }

  Widget bodyStartScreen(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Horários Possíveis",
            style: TextStyle(
                fontSize: 18.0
            ),
          ),
        ),
        Expanded(
          child: listTiles(),
        )
      ],
    );
  }

  Widget listTiles(){
    return Container(
      margin: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _listTiles.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: ListTile(
              title: Text(_listTiles[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: _iconsColors[index],
                      size: 20.0,
                    ),
                    onPressed: () {
                      setState(() {
                        (_iconsColors[index] == standardIconColor) ? _iconsColors[index] = alternateIconColor : _iconsColors[index] = standardIconColor;
                      });
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





