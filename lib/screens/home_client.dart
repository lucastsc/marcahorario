import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marca_horario/misc/general_functions.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/model/user.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:http/http.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';

class HomeClient extends StatefulWidget {

  final classNameDB;
  final username;
  HomeClient({Key key, @required this.classNameDB, this.username}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  String text = '';

  Future<void> initData() async {
    //checks the health of the Parse connection
    final ParseResponse response = await Parse().healthCheck();

    if (response.success) {
      await test();
      text += 'testing\n';
      print(text);
    } else {
      text += 'Server health check failed';
      print(text);
    }
  }

  //test function starts the live query with the Parse Server
  Future<void> test() async {
    final LiveQuery liveQuery = LiveQuery();

    //makes a query to the Parse Server. Every change in every field in the "Data" class will be reported!
    QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject("Data"));

    //establishes a subscription effectively. The tracking starts here.
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value) {
      setState(() {

      });
    });

    subscription.on(LiveQueryEvent.update, (value) {
      setState(() {

      });
    });

    subscription.on(LiveQueryEvent.delete, (value) {
      setState(() {

      });
    });
  }

  //when the screen starts, start tracking with the live query by initData()
  @override
  void initState() {
    super.initState();
    initData();
  }

  Color standardIconColor = Colors.black;
  Color alternateIconColor = Colors.green;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        setState(() {

        });},
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Marca Horário'),
          ),
          // body: Center(
          //   child: Text('Hello World'),
          body: bodyStartScreen()
      ),
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
            print("DATALIST: " + dataList.toString());
            sortDataListByDateTime(dataList);
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (_, position) {
                    return frontCards(dataList, position);
                  },
                  itemCount: dataList.length,
                ),
              );

          } else {
            return Center(
              child: warningLoading(),
            );
          }
        },
          future: getDataList(),
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }

  //return the cards showed in the home client screen
  Widget frontCards(List<Data> dataList, int position){
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(dataList[position].dateTime == null ? "modificando...aguarde" : dataList[position].dateTime),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        //if the card client name is equal to the username logged in, it changes the color of the checkbox
                        activeColor: dataList[position].client == widget.username ? Colors.green : Colors.red,
                        value: dataList[position].clientCheckBox,
                        onChanged: (bool value) async {
                          //if the card was not checked yet or if the check was made by the user that is logged in, then...
                          if(dataList[position].client  == widget.username || dataList[position].client == "nenhum"){ //todo:change the name "nenhum" by a variable called "blank client"
                            //returns how many schedules the client made
                            var countClientSchedules = await DataUtils.verifyClientAlreadyScheduled("client", widget.username);

                            //if user have not scheduled yet
                            if(countClientSchedules == 0){
                              //if value goes to false, change the client ownership and updates data in the database
                              value == false ? dataList[position].client = "nenhum" : dataList[position].client = widget.username;
                              dataList[position].clientCheckBox = value;

                              //retrieve information about the logged user (specifically the phone number)
                              Future<List<User>> response = getUser(widget.username);
                              List<User> userList = await response;
                              dataList[position].clientPhone = userList.first.phone;

                              DataUtils.updateData(dataList[position]);
                            }

                            //if user have already scheduled
                            if(countClientSchedules == 1){
                              if(dataList[position].client  == widget.username){
                                //if value goes to false, change the client ownership and updates data in the database
                                value == false ? dataList[position].client = "nenhum" : dataList[position].client = widget.username;
                                dataList[position].clientCheckBox = value;
                                DataUtils.updateData(dataList[position]);
                              }else{
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Você já tem horário marcado!"), duration: Duration(milliseconds: 1500),));
                              }
                            }

                          }else{
                            //if the client logged in is different from the client of the card
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Você não pode alterar a marcação de outra pessoa.Tente outro horário!"), duration: Duration(milliseconds: 1500),));
                          }
                          setState(() {
                          });

                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 16.0),),
              Flexible(
                child: Text("Funcionário: " + dataList[position].employee),
              )
            ],
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 16.0),),
              Flexible(
                child: widget.username == dataList[position].client ? Text("Cliente: " + dataList[position].client,style: TextStyle(fontWeight: FontWeight.bold),) : Text("Cliente: " + dataList[position].client ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //shows a widget if there is no data for the created company yet
  Widget warningLoading(){
    return Container(
      child: Card(
        child: ListTile(
          title: Text("Aqui você verá disponibilidades de horários, quando o prestador de serviços disponibilizar!"),
        ),
      ),
    );
  }

  Future <List<Data>> getDataList() async {
    List<Data> dataList = [];
    //gets exclusively data relatively to widget.classnameDB
    ParseResponse response = await DataUtils.getDataList(
        "companyName", widget.classNameDB);
    if (response.success) {
      for (ParseObject parseObject in response.results) {
        dataList.add(Data.fromJson(parseObject.toJson()));
      }
    } else {
      print(response.error);
    }

    return dataList;
  }

  Future<List<User>> getUser(String name) async {
    List<User> userList = [];
    //User user;
    //gets exclusively data relatively to widget.classnameDB
    ParseResponse response = await DataUtils.getUser(
        "username", name);
    if (response.success) {
      print("RESULTAAAAAAAADO: " + response.result.toString());
      for (ParseObject parseObject in response.results) {
        userList.add(User.fromJson(parseObject.toJson()));
      }
      // ParseObject parseObject = response.result;
      // user = User.fromJson(parseObject.toJson());
    } else {
      print(response.error);
    }

    return userList;
  }




}
