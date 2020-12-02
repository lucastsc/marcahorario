import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marca_horario/main.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:marca_horario/screens/home.dart';
import 'package:marca_horario/screens/home_page.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';
import 'package:marca_horario/screens/home_client.dart';
import 'package:marca_horario/screens/login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordUserController = TextEditingController();
  TextEditingController _userCompanyNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPhoneController = TextEditingController();

  TextEditingController _companyController = TextEditingController();
  TextEditingController _passwordCompanyController = TextEditingController();
  TextEditingController _emailCompanyController = TextEditingController();

  bool _companyVisibility = false;
  bool _clientVisibility = false;

  var maskFormatter = new MaskTextInputFormatter(mask: '(##) #####-####', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Container(
        child: showBody(),
      ),
    );
  }

  Widget showBody(){

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                print("card1");
                _companyVisibility == false ? _companyVisibility = true : _companyVisibility = false;
                _clientVisibility = false;
                print(_companyVisibility);
                setState(() {
                  print("setStated!!!");
                });
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.apartment),
                  title: Text("Sou empresa"),
                ),
              ),
            ),
            Visibility(
              child: companyFields(),
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              visible: _companyVisibility,
            ),
            InkWell(
              onTap: (){
                print("card2");
                _clientVisibility == false ? _clientVisibility = true : _clientVisibility = false;
                _companyVisibility = false;
                print(_clientVisibility);
                setState(() {
                  print("setStated!!!");
                });
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Sou cliente"),
                ),
              ),
            ),
            Visibility(
              child: clientFields(),
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              visible: _clientVisibility,
            ),
          ],
        ),
      ),
    );
  }

  Widget companyFields(){
    return Builder(
      builder: (context){
        return Container(
          child: Column(
            children: [
              TextField(
                controller: _companyController,
                decoration: InputDecoration(
                    labelText: "Nome da empresa (sem espaços)"
                ),
              ),
              TextField(
                controller: _passwordCompanyController,
                decoration: InputDecoration(
                    labelText: "Senha"
                ),
              ),
              TextField(
                controller: _emailCompanyController,
                decoration: InputDecoration(
                    labelText: "Email"
                ),
              ),
              FlatButton(
                onPressed: () async{

                  ParseUser user = ParseUser(_companyController.text,_passwordCompanyController.text,_emailCompanyController.text)
                    ..set("isCompany", true);


                  if(await DataUtils.verifyUserIsCompany(_companyController.text)){
                    snackBarCustomError(context, "Essa empresa já existe!Tente outro nome.");
                  }else{
                    var response = await user.save();
                    if (response.success) {
                      print("CRIACAO EMPRESA: " + response.result.toString());
                      print(response.result);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }else{
                      print(response.error);
                      snackBarCustomError(context, "Erro: " + response.error.type);
                    }
                  }

                },
                child: Text("Cadastrar"),
              )
            ],
          ),
        );
      },
    );
  }

  Widget clientFields(){
    return Container(
      child: Column(
        children: [
          TextField(
            controller: _userController,
            decoration: InputDecoration(
                labelText: "Usuário"
            ),
          ),
          TextField(
            controller: _passwordUserController,
            decoration: InputDecoration(
                labelText: "Senha"
            ),
          ),
          TextField(
            controller: _userEmailController,
            decoration: InputDecoration(
                labelText: "Email"
            ),
          ),
          TextField(
            controller: _userPhoneController,
            decoration: InputDecoration(
              labelText: "Telefone"
            ),
              inputFormatters: [maskFormatter]
          ),
          FlatButton(
            onPressed: () async{
              ParseUser user = ParseUser(_userController.text,_passwordUserController.text,_userEmailController.text)
                ..set("phone", _userPhoneController.text)
                ..set("isCompany", false);

              var response = await user.save();
              if (response.success) {
                print("CRIACAO USUARIO: " + response.result.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }else{
                print(response.error);
                snackBarCustomError(context, "Erro: " + response.error.type);
              }
            },
            child: Text("Cadastrar"),
          )
        ],
      ),
    );
  }

  Widget snackBarCustomError(BuildContext context, String text){
    String answer = text;
    final snackBar = SnackBar(content: Text(answer));
    Scaffold.of(context).showSnackBar(snackBar);

  }
}




