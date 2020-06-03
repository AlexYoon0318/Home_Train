import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:home_t/option_page/adding_exercise_list.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddingExercise extends StatefulWidget {
  @override
  _AddingExerciseState createState() => _AddingExerciseState();
}

class _AddingExerciseState extends State<AddingExercise> {
  var textEditingController_Machine = TextEditingController();
  var textEditingController_Exercise = TextEditingController();
  var _selectedmachine;
  var _selectedexercise;
  Color _selectedColor;
  var id;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadID();
    _selectedColor = Colors.transparent;
  }


  _loadID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = (prefs.getString('UID') ?? 0);
    });
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    textEditingController_Machine.text = _selectedmachine;
    textEditingController_Exercise.text = _selectedexercise;
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController_Machine.dispose();
    textEditingController_Exercise.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _List(),
                  _getNewMachine(),
                ],
              )
          ),
        )
    );
  }

  Widget _getNewMachine() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: '새로운 운동기구'),
              controller: textEditingController_Machine,
            ),
          ),
          //Text('새로운 운동'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                decoration: InputDecoration(hintText: '새로운 운동'),
                controller: textEditingController_Exercise
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child:Text('NFC등록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                onPressed: (){
                  FlutterNfcReader.checkNFCAvailability();
                  if(NFCAvailability.available != null) {
                    if(textEditingController_Machine == null){
                      _showNFCWarningDialog2(context);
                    }else{
                      _showNFCDialog(context);}
                  }
                  else{
                    _showNFCWarningDialog(context);
                  }

                },
              ),
              RaisedButton(
                child:Text('추가하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                onPressed: () {
                  String a = textEditingController_Machine.text;
                  String b = textEditingController_Exercise.text;
                  var doc = Firestore.instance.collection('Users').document('$id').collection('Machine').document('$a');
                  doc.collection('exercise').document('$b').setData({'asd': a+b});
                  doc.setData({'11':22});
                  textEditingController_Exercise.clear();
                  textEditingController_Machine.clear();
                  _selectedmachine = null;
                  _selectedexercise = null;
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>AddingExerciseListPage()));
                },
              ),
              RaisedButton(
                color: Colors.red,
                child:Text('삭제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                onPressed: (){
                  if(_selectedexercise != null) {
                    Firestore.instance.collection('Users').document('$id').collection('Machine').document(
                        '$_selectedmachine').collection('exercise').document(
                        '$_selectedexercise').delete();
                  }else{
                    Firestore.instance.collection('Users').document('$id').collection('Machine').document('$_selectedmachine').delete();
                  }
                  textEditingController_Exercise.clear();
                  textEditingController_Machine.clear();
                  _selectedmachine = null;
                  _selectedexercise = null;
                  },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _List() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 400,
          width: 150,
          decoration: BoxDecoration(border: Border.all()),
          child: Ink(
            color: Colors.white,
            child: StreamBuilder(
                stream: Firestore.instance.collection('Users').document('$id').collection('Machine').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                            color: _selectedmachine == snapshot.data.documents[index].documentID.toString() ? Colors.blue : Colors.white
                          ),
                          child: ListTile(
                            title: AutoSizeText(
                              snapshot.data.documents[index].documentID.toString(), style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                              maxLines: 1,
                            ),
                            onTap: (){
                              setState(() {
                                _selectedmachine = snapshot.data.documents[index].documentID.toString();
                                //_selectedColor = Colors.amber;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                }
            ),
          ),
        ),
        Container(
          height: 400,
          width: 150,
          decoration: BoxDecoration(border: Border.all()),
          child: Ink(
            color: Colors.white,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Users').document('$id').collection('Machine').document('$_selectedmachine').collection('exercise').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Text('Loading');
                  } else{
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                              color: _selectedexercise == snapshot.data.documents[index].documentID.toString() ? Colors.blue : Colors.white
                          ),
                          child: ListTile(
                            title: AutoSizeText(
                              snapshot.data.documents[index].documentID.toString(), style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                              maxLines: 1,
                            ),
                            onTap: (){
                              setState(() {
                                _selectedexercise = snapshot.data.documents[index].documentID.toString();
                                //_selectedColor = Colors.amber;
                              });
                            },
                          ),
                        );
                      },
                    );
                  }
                }
            ),
          ),
        )
      ],
    );
  }

  void _showNFCDialog(BuildContext context) async{
    setState(() {
      FlutterNfcReader.write(" ", textEditingController_Machine.text).then((value) {
        print(value.content);
        Navigator.pop(context);
        _showNFCCompleteDialog(context);
      });
    });
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("기기를 NFC태그에 접촉해주세요."),
          );
        }
    );
  }

  void _showNFCCompleteDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("NFC가 등록되었습니다."),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context, "OK");
                },
              )
            ],
          );
        }
    );
  }

  void _showNFCWarningDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("이 기기는 NFC를 지원하지 않습니다."),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context, "OK");
                },
              )
            ],
          );
        }
    );
  }

  void _showNFCWarningDialog2(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("등록할 기구의 이름을 기입해주세요."),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context, "OK");
                },
              )
            ],
          );
        }
    );
  }
}