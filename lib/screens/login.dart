import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marca_horario/main.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:marca_horario/screens/home.dart';
//import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';
import 'package:marca_horario/screens/home_client.dart';
import 'package:marca_horario/network_utils/data_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordUserController = TextEditingController();
  TextEditingController _userCompanyNameController = TextEditingController();

  TextEditingController _companyController = TextEditingController();
  TextEditingController _passwordCompanyController = TextEditingController();

  bool _companyVisibility = false;
  bool _clientVisibility = false;

  //var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Scaffold(
        body: showBody(),
      ),
    );
  }

  Widget showBody(){

    return Container(
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
    );
  }

  Widget companyFields(){
    return Container(
      child: Builder(
        builder: (context){
          return Column(
            children: [
              TextField(
                controller: _companyController,
                decoration: InputDecoration(
                    labelText: "Login da empresa"
                ),
              ),
              TextField(
                controller: _passwordCompanyController,
                decoration: InputDecoration(
                    labelText: "senha"
                ),
              ),
              FlatButton(
                onPressed: () async{
                  ParseUser user = ParseUser(_companyController.text,_passwordCompanyController.text,"");
                  var response = await user.login();

                  //verify of user login was successfull
                  if (response.success) {
                    //verify if is a company name or a user
                    if(await DataUtils.verifyUserIsCompany(_companyController.text)){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home(classNameDB: _companyController.text)),
                      );
                    }else{
                      snackBarCustomError(context, "Não é uma empresa");
                    }

                  }else{
                    snackBarLoginParseResponseError(context, response);
                  }
                },
                child: Text("Logar"),
              )
            ],
          );
        },
      )
    );
  }

  Widget clientFields(){
    return Container(
      //wrap into a builder to make scaffold work
      child: Builder(
        builder: (context){
          return Column(
            children: [
              TextField(
                controller: _userCompanyNameController,
                decoration: InputDecoration(
                    labelText: "Nome da empresa"
                ),
              ),
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
              FlatButton(

                onPressed: () async{

                  if(await DataUtils.verifyUserIsCompany(_userController.text)){
                    snackBarCustomError(context, "Não é nome de usuário");
                  }else{
                    ParseUser user = ParseUser(_userController.text,_passwordUserController.text,"");
                    var response = await user.login();

                    //verify of user login was successfull
                    if (response.success) {

                      //verify if company name exists
                      if(await DataUtils.verifyCompanyExists("companyName", _userCompanyNameController.text)){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeClient(classNameDB: _userCompanyNameController.text,username: _userController.text,)),
                        );
                      }else{
                        snackBarCustomError(context, "Essa empresa não existe ainda.");
                      }

                    }else{
                      snackBarLoginParseResponseError(context, response);
                    }
                  }


                },
                child: Text("Logar"),
              )
            ],
          );
        },
      )
    );
  }

  Widget snackBarLoginParseResponseError(BuildContext context, ParseResponse response){
    String answer = response.error.type != null ? "Erro no login: " + response.error.type : "Erro no login. Motivo desconhecido.";
    final snackBar = SnackBar(content: Text(answer));
    Scaffold.of(context).showSnackBar(snackBar);

  }

  Widget snackBarCustomError(BuildContext context, String text){
    String answer = text;
    final snackBar = SnackBar(content: Text(answer));
    Scaffold.of(context).showSnackBar(snackBar);

  }


}



