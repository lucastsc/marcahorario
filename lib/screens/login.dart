import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //createItem(nomeEmpresaController.text);
          ParseUser usuario = ParseUser(_userController.text,_passwordController.text,_emailController.text);
          var response = await usuario.login();
          if (response.success) {
            print(response.result);
          }else{
            print(response.error);
          }
        },
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                  labelText: "usuario"
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "senha"
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "email"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
