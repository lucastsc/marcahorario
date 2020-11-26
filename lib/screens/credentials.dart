import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';

class CredentialsScreen extends StatefulWidget {
  @override
  _CredentialsScreenState createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {

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

  TextEditingController nomeEmpresaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //createItem(nomeEmpresaController.text);
          query(nomeEmpresaController.text);
        },
      ),
      appBar: AppBar(
        title: Text('Credenciais'),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: nomeEmpresaController,
              decoration: InputDecoration(
                  labelText: "Nome da empresa"
              ),
            ),
          ],

        ),
      ),
    );
  }

  Future<void> createItem(String name) async {
    final ParseObject newObject = ParseObject(name);
    newObject.set<String>('name', 'testItem');
    newObject.set<int>('age', 26);

    final ParseResponse apiResponse = await newObject.create();

    if (apiResponse.success && apiResponse.count > 0) {
      print(keyAppName + ': ' + apiResponse.result.toString());
    }
  }

  Future<void> query(String name) async {
    final QueryBuilder<ParseObject> queryBuilder =
    QueryBuilder<ParseObject>(ParseObject(name))
      ..whereEqualTo("age", 26);

    final ParseResponse apiResponse = await queryBuilder.query();

    if (apiResponse.success && apiResponse.count > 0) {
      final List<ParseObject> listFromApi = apiResponse.result;
      final ParseObject parseObject = listFromApi?.first;
      print('Result: ${parseObject.toString()}');
    } else {
      print('Result: ${apiResponse.error.message}');
    }
  }
}

