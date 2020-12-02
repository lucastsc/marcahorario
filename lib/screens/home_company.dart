import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:marca_horario/model/data.dart';
import 'package:marca_horario/network_utils/data_utils.dart';
import 'package:http/http.dart';
import 'package:marca_horario/screens/credentials.dart';
import 'package:marca_horario/screens/login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:marca_horario/constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class HomeCompany extends StatefulWidget {

  final classNameDB;
  //this screen requires the name of the company to generate customized list view only with data relatively to that company
  HomeCompany({Key key, @required this.classNameDB}) : super(key: key);

  @override
  _HomeCompanyState createState() => _HomeCompanyState();
}

class _HomeCompanyState extends State<HomeCompany> {

  String text = '';

  //starts communication with the parse server.
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

  //function for starting the live query
  Future<void> test() async {
    final LiveQuery liveQuery = LiveQuery();

    QueryBuilder<ParseObject> query =
    QueryBuilder<ParseObject>(ParseObject("Data"));

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

  //when this screen starts, it start the communication with the parse server.
  @override
  void initState() {
    super.initState();
    initData();
  }

  var _listTiles = List<String>();
  Color _iconColor = Colors.black;
  Color standardIconColor = Colors.black;
  Color alternateIconColor = Colors.green;
  TextEditingController _nameController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String standardTileTitle = "Adicione um horário disponível...";
  String _titleTile = "Adicione um horário disponível...";
  String _tileSubtitle = "Edite o nome do funcionário...";
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
          appBar: AppBar(
            title: Text('Marca Horário'),
          ),
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
            return warningLoading();
          }
        },
          future: getDataList(),
        ),
        Divider(
          color: Colors.black,
        ),
        scheduleTile()
      ],
    );
  }

  //cards exhibited in the company's screen
  Widget frontCards(List<Data> dataList, int position){
    String phoneNumber = dataList[position].clientPhone;

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
                      IconButton(icon: Icon(Icons.edit), onPressed: () {
                        //Show dialog box to update item
                        showUpdateDialog(dataList[position]);
                      }),
                        dataList[position].clientCheckBox == true ? Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.check_circle, color: Colors.grey,),
                      //Show dialog box to delete item
                      IconButton(icon: Icon(Icons.delete), onPressed: () {
                        deleteData(dataList[position].objectId);
                      }),
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
              Flexible(//todo: change the name "nenhum"
                child: dataList[position].client != "nenhum" ? Text("Cliente: " + dataList[position].client, style: TextStyle(fontWeight: FontWeight.bold)) : Text("Cliente: " + dataList[position].client)
              ),
            ],
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 16.0),),

              (phoneNumber != null && phoneNumber != "") ? iconPhoneButton(phoneNumber) :  Visibility(child: iconPhoneButton(phoneNumber),visible: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget iconPhoneButton(String phoneNumber){
    return IconButton(
      icon: Icon(Icons.phone),
      onPressed: (){
        phoneNumber != null ?  UrlLauncher.launch("tel://$phoneNumber") : _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Não há telefone!"), duration: Duration(seconds: 1),)) ;
      },
    );
  }

  Widget warningLoading(){
    return Container(
      child: Card(
        child: ListTile(
          title: Text("Não há disponibilidade de funcionários ainda.Adicione!"),
        ),
      ),
    );
  }

  void invokeDatePicker(){
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 1, 1),
        maxTime: DateTime(2021, 12, 31),
        onChanged: (date) {
          print('change $date');
        },
        onConfirm: (date) {
          print('confirm $date');
          _listTiles.add(DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString());
          _titleTile = DateFormat.yMMMEd('pt_BR').add_Hm().format(date).toString();

          setState(() {

          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.pt);
  }

  void showUpdateDialog(Data data) {
    _nameController.text = data.employee;
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Atualizar funcionário disponível",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
              data.employee = _nameController.text;
              updateData(data);
            }, child: Text("Atualizar")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Cancelar")),
          ],
        )
    );

  }

  Widget scheduleTile(){
    return Card(
      color: Colors.grey,
      child: ListTile(
        title: Text(_titleTile),
        subtitle: Text(_tileSubtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              tooltip: "Adicionar nome do funcionário",
              icon: Icon(
                Icons.edit,
                color: standardIconColor,
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  employeeAvailable();
                });
              },
            ),
            IconButton(
              tooltip: "Adicionar horário disponível",
              icon: Icon(
                Icons.access_time,
                color: standardIconColor,
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  invokeDatePicker();
                });
              },
            ),
            IconButton(
              tooltip: "Confirmar disponibilidade do funcionário",
              icon: Icon(
                Icons.check_circle_outline,
                color: _iconColor,
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  (_titleTile != standardTileTitle) ? confirmSchedule() : fillTimeDialog();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void fillTimeDialog(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Text("Insira o horário disponível!"),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("OK")),
          ],
        )
    );
  }

  void employeeAvailable(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Funcionário",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {

              Navigator.pop(context);
              //addTodo();
              setState(() {
                _tileSubtitle = _nameController.text;
              });

            }, child: Text("Inserir")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tileSubtitle = " ";
              });

            }, child: Text("Desfazer")),
          ],
        )
    );
  }

  void confirmSchedule(){
    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
              width: double.maxFinite,
              child: Text("Confirma disponibilidade?")
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
              //addTodo();
              addData();
              setState(() {
                _iconColor = alternateIconColor;
                _tileSubtitle = _nameController.text;
              });

            }, child: Text("Confirma")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
              setState(() {
                _iconColor = standardIconColor;
                _tileSubtitle = " ";
              });

            }, child: Text("Não")),
          ],
        )
    );
  }

  void addData() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      children: <Widget>[
        Text("Adicionando informações..."),
        CircularProgressIndicator(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
      duration: Duration(minutes: 1),
    ));

    Data data = Data(employee: _tileSubtitle, dateTime: _titleTile, companyName: widget.classNameDB, client: "nenhum",clientCheckBox: false);

    DataUtils.addData(data)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 201) {
        //Successful
        _nameController.text = "";

        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Informações disponibilizadas!"), duration: Duration(seconds: 1),));

        setState(() {
          //Update UI
        });

      }

    });

  }

  void deleteData(String objectId) {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  <Widget>[
        Text("Excluindo disponibilidade..."),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    DataUtils.deleteData(objectId, widget.classNameDB)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: (Text("Disponibilidade excluída!")),duration: Duration(seconds: 1),));
        setState(() {

        });
      } else {
        //Handle error
      }
    });

  }

  void updateData(Data data) {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Atualizando disponibilidade..."),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    DataUtils.updateData(data)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        _nameController.text = "";
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: (Text("Disponibilidade atualizada!"))));
        setState(() {

        });
      } else {
        //Handle error
      }
    });

  }

  Future <List<Data>> getDataList() async{

    List<Data> dataList = [];

    ParseResponse response = await DataUtils.getDataList(
        "companyName", widget.classNameDB);
    print("RESPONSE RESULTS: " + response.results.toString());

    if (response.success) {
      for (ParseObject parseObject in response.results) {
        dataList.add(Data.fromJson(parseObject.toJson()));
        print("DATA: " + parseObject.toString());
      }
    } else {
      print(response.error);
    }

    return dataList;

    // Response response = await DataUtils.getDataList("companyName", widget.classNameDB);
    // //Response response = await DataUtils.getDataList("companyName",widget.classNameDB);
    // print("Code is ${response.statusCode}");
    // print("Response is ${response.body}");
    //
    // if (response.statusCode == 200) {
    //   var body = json.decode(response.body);
    //   var results = body["results"];
    //
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