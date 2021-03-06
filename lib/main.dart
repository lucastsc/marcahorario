// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marca_horario/screens/home_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'constants.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Parse().initialize(
        kParseApplicationId,
        kParseServerUrl,
        clientKey: kParseClientKey,
        masterKey: kParseMasterKey,
        debug: true,
        liveQueryUrl: kLiveQueryUrl,
        autoSendSessionId: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        home: HomePage()
    );
  }
}






