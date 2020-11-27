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
  HomeClient({Key key, @required this.classNameDB}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  String text = '';

  Future<void> initData() async {

    // await Parse().initialize(
    //   kParseApplicationId,
    //   kParseServerUrl,
    //   masterKey: kParseMasterKey,
    //   clientKey: kParseClientKey,
    //   debug: true,
    //   liveQueryUrl: kLiveQueryUrl,
    //   autoSendSessionId: true,
    // );

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
    QueryBuilder<ParseObject>(ParseObject(widget.classNameDB));

    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value) {
      setState(() {

      });
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);
      print((value as ParseObject).updatedAt);
      print((value as ParseObject).createdAt);
      print((value as ParseObject).get('objectId'));
      print((value as ParseObject).get('updatedAt'));
      print((value as ParseObject).get('createdAt'));
    });

    subscription.on(LiveQueryEvent.update, (value) {
      setState(() {

      });
      print('*** UPDATE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);
      print((value as ParseObject).updatedAt);
      print((value as ParseObject).createdAt);
      print((value as ParseObject).get('objectId'));
      print((value as ParseObject).get('updatedAt'));
      print((value as ParseObject).get('createdAt'));
    });

    subscription.on(LiveQueryEvent.delete, (value) {
      setState(() {

      });
      print('*** DELETE ***: ${DateTime.now().toString()}\n $value ');
      print((value as ParseObject).objectId);
      print((value as ParseObject).updatedAt);
      print((value as ParseObject).createdAt);
      print((value as ParseObject).get('objectId'));
      print((value as ParseObject).get('updatedAt'));
      print((value as ParseObject).get('createdAt'));
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
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){
          //     // var user =  ParseUser("TestFlutter", "TestPassword123", "TestFlutterSDK@gmail.com").create();
          //     // var teste = ParseObject('Testando').create();
          //   },
          // ),
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

            if(dataList.isNotEmpty){
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (_, position) {
                    return Card(
                      child: ListTile(
                        title: Text(dataList[position].dateTime == null ? "modificando...aguarde" : dataList[position].dateTime),
                        subtitle: Text(dataList[position].employee == null ? "modificando...aguarde": dataList[position].employee),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.edit), onPressed: () {
                              //Show dialog box to update item
                              //showUpdateDialog(dataList[position]);
                            }),
                            IconButton(icon: Icon(Icons.check_circle, color: Colors.green,), onPressed: () {

                            }),
                            //Show dialog box to delete item
                            IconButton(icon: Icon(Icons.delete), onPressed: () {
                              //deleteData(dataList[position].objectId);
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: dataList.length,
                ),
              );
            }else{
              return warningLoading();
            }



          } else {
            return Center(
              child: CircularProgressIndicator(),
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

  Widget warningLoading(){
    return Container(
      child: Card(
        child: ListTile(
          title: Text("Aqui você verá disponibilidades de horários, quando o prestador de serviços disponibilizar!"),
        ),
      ),
    );
  }

  Future <List<Data>> getDataList() async{

    List<Data> dataList = [];

    Response response = await DataUtils.getDataList(widget.classNameDB);
    print("Code is ${response.statusCode}");
    print("Response is ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var results = body["results"];

      for (var data in results) {
        dataList.add(Data.fromJson(data));
      }

    } else {
      //Handle error
    }

    return dataList;
  }

}
