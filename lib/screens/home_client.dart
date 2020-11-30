import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:marca_horario/model/data.dart';
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

  Future<void> test() async {

    final LiveQuery liveQuery = LiveQuery();

    QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject("Data"));

    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value) {
      setState(() {

      });
      // print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      // print((value as ParseObject).objectId);
      // print((value as ParseObject).updatedAt);
      // print((value as ParseObject).createdAt);
      // print((value as ParseObject).get('objectId'));
      // print((value as ParseObject).get('updatedAt'));
      // print((value as ParseObject).get('createdAt'));
    });

    subscription.on(LiveQueryEvent.update, (value) {
      setState(() {

      });
      // print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
      // print((value as ParseObject).objectId);
      // print((value as ParseObject).updatedAt);
      // print((value as ParseObject).createdAt);
      // print((value as ParseObject).get('objectId'));
      // print((value as ParseObject).get('updatedAt'));
      // print((value as ParseObject).get('createdAt'));
    });

    subscription.on(LiveQueryEvent.delete, (value) {
      setState(() {

      });
      // print('*** DELETE ***: ${DateTime.now().toString()}\n $value ');
      // print((value as ParseObject).objectId);
      // print((value as ParseObject).updatedAt);
      // print((value as ParseObject).createdAt);
      // print((value as ParseObject).get('objectId'));
      // print((value as ParseObject).get('updatedAt'));
      // print((value as ParseObject).get('createdAt'));
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  var _listTiles = List<String>();
  Color _iconColor = Colors.black;
  Color standardIconColor = Colors.black;
  Color alternateIconColor = Colors.green;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndexBottomNavBar = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _clientCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        setState(() {

        });},
      child: Scaffold(
          key: _scaffoldKey,
          //bottomNavigationBar: bottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              // var user =  ParseUser("TestFlutter", "TestPassword123", "TestFlutterSDK@gmail.com").create();
              // var teste = ParseObject('Testando').create();
              getDataList();
            },
          ),
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
        // scheduleTile()
      ],
    );
  }

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
                        value: dataList[position].clientCheckBox,
                        onChanged: (bool value) async {
                          if(dataList[position].client  == widget.username || dataList[position].client == "nenhum"){

                            var countClientSchedules = await DataUtils.verifyClientAlreadyScheduled("client", widget.username);

                            //if user have not scheduled yet
                            if(countClientSchedules == 0){
                              //if value goes to false, change the client ownership
                              value == false ? dataList[position].client = "nenhum" : dataList[position].client = widget.username;
                              dataList[position].clientCheckBox = value;
                              DataUtils.updateData(dataList[position]);
                            }

                            //if user have already scheduled
                            if(countClientSchedules == 1){
                              if(dataList[position].client  == widget.username){
                                //if value goes to false, change the client ownership
                                value == false ? dataList[position].client = "nenhum" : dataList[position].client = widget.username;
                                dataList[position].clientCheckBox = value;
                                DataUtils.updateData(dataList[position]);
                              }else{
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Você já tem horário marcado!"), duration: Duration(milliseconds: 1500),));
                              }
                            }

                          }else{
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
              )
            ],
          ),
        ],
      ),
    );
  }

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

      // Response response = await DataUtils.getDataList(widget.classNameDB);
      // //Response response = await DataUtils.getDataList("companyName",widget.classNameDB);
      // print("Code is ${response.statusCode}");
      // print("Response is ${response.body}");
      //
      // if (response.statusCode == 200) {
      //   var body = json.decode(response.body);
      //   var results = body["results"];
      //   print("BODY: " + body.toString());
      //   print("RESULTS: "+results.toString());
      //   for (var data in results) {
      //     dataList.add(Data.fromJson(data));
      //   }
      //
      // } else {
      //   //Handle error
      // }
      //
      // return dataList;
    }
}

