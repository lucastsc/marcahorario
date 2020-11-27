import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marca_horario/main.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordUserController = TextEditingController();

  TextEditingController _companyController = TextEditingController();
  TextEditingController _passwordCompanyController = TextEditingController();

  bool _companyVisibility = false;
  bool _clientVisibility = false;

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

        },
      ),
      body: Container(
        child: showBody(),
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
      child: Column(
        children: [
          TextField(
            controller: _companyController,
            decoration: InputDecoration(
                labelText: "usuario"
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
              if (response.success) {
                print(response.result);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyApp()),
                // );
              }else{
                print(response.error);
              }
            },
            child: Text("Logar"),
          )
        ],
      ),
    );
  }

  Widget clientFields(){
    return Container(
      child: Column(
        children: [
          TextField(
            controller: _userController,
            decoration: InputDecoration(
                labelText: "usuario"
            ),
          ),
          TextField(
            controller: _passwordUserController,
            decoration: InputDecoration(
                labelText: "senha"
            ),
          ),
          FlatButton(
            onPressed: () async{
              ParseUser user = ParseUser(_userController.text,_passwordUserController.text,"");
              var response = await user.login();
              if (response.success) {
                print(response.result);
              }else{
                print(response.error);
              }
            },
            child: Text("Logar"),
          )
        ],
      ),
    );
  }

  Widget toggleButtonChoose(){
    List<bool> _selections = List.generate(2, (_) => false);

    return ToggleButtons(
      children: [
        Icon(Icons.apartment),
        Icon(Icons.person)
      ],
      isSelected: _selections,
      onPressed: (index){
        setState(() {
          print(index);
        });
      },
    );
  }

  }



