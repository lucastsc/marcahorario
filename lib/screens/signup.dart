import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marca_horario/main.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:marca_horario/screens/home_company.dart';
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

  //client fields controllers
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordUserController = TextEditingController();
  TextEditingController _userCompanyNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPhoneController = TextEditingController();

  //company fields controllers
  TextEditingController _companyController = TextEditingController();
  TextEditingController _passwordCompanyController = TextEditingController();
  TextEditingController _emailCompanyController = TextEditingController();

  //turn on or off client and company fields, depending on where it's clicked
  bool _companyVisibility = false;
  bool _clientVisibility = false;

  //mask formatter for the telephone field (client)
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

  //contains client and company fields (TextEditings)
  Widget showBody(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                _companyVisibility == false ? _companyVisibility = true : _companyVisibility = false;
                _clientVisibility = false;
                setState(() {

                });
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.apartment),
                  title: Text("Cadastrar minha empresa"),
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
                _clientVisibility == false ? _clientVisibility = true : _clientVisibility = false;
                _companyVisibility = false;
                setState(() {

                });
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Cadastrar como cliente"),
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
    //Builder to give a context to show snackbars in case of errors.They need a context.
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
              //button to signup
              FlatButton(
                onPressed: () async{
                  //creates a user that is a company (see the isCompany = true attribute)
                  ParseUser user = ParseUser(_companyController.text,_passwordCompanyController.text,_emailCompanyController.text)
                    ..set("isCompany", true);

                  //if this company exists in the _User class...
                  if(await DataUtils.verifyUserIsCompany(_companyController.text)){
                    snackBarCustomError(context, "Essa empresa já existe!Tente outro nome.");
                  }else{
                    //if this company doesn't exists in the _User class...
                    //saves the user in the database class _User
                    var response = await user.save();
                    //if the user was successfully saved to the _User class, go to HomePage()
                    if (response.success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }else{
                      //if the user wasn't successfully saved to the _User class, shows error in snackbar
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
    //a builder to give a context to show snackbars in case of errors
    return Builder(
      builder: (context){
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
              //a button to signup
              FlatButton(
                onPressed: () async{
                  //creates a user of client type (see the isCompany = false attribute)
                  ParseUser user = ParseUser(_userController.text,_passwordUserController.text,_userEmailController.text)
                    ..set("phone", _userPhoneController.text)
                    ..set("isCompany", false);

                  var response = await user.save();
                  //if the user of client type is successfully saved into the _User class database...
                  if (response.success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }else{
                    //if the user of client type was not successfully saved into the _User class database...
                    snackBarCustomError(context, "Erro: " + response.error.type);
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

  //custom snackbar for showing messages in case of error
  Widget snackBarCustomError(BuildContext context, String text){
    String answer = text;
    final snackBar = SnackBar(content: Text(answer));
    Scaffold.of(context).showSnackBar(snackBar);

  }
}




