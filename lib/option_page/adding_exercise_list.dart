import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddingExerciseListPage extends StatefulWidget {
  @override
  _AddingExerciseListPageState createState() => _AddingExerciseListPageState();
}

class _AddingExerciseListPageState extends State<AddingExerciseListPage> {
  var _selectedmachine;
  var _selectedexercise;
  var id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadID();
  }

  _loadID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = (prefs.getString('UID') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _List(),
          RaisedButton(
            child: Text('추가하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            onPressed: (){
              Firestore.instance.collection('Users').document('$id').collection('Machine').document('$_selectedmachine').setData({'1':"1"});
              Firestore.instance.collection('Users').document('$id').collection('Machine').document('$_selectedmachine').collection('exercise').document('$_selectedexercise').setData({'1' : "1"});
            },
          )
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
                stream: Firestore.instance.collection('Machine').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading');
                  } else {
                    return ListView(
                      children: snapshot.data.documents.map((document){
                        return ListTile(
                          //onLongPress: ,
                          dense: true,
                          enabled: true,
                          selected: true,
                          title: AutoSizeText(document.documentID, style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                            maxLines: 1,
                          ),
                          onTap: (){
                            setState(() {
                              _selectedmachine = document.documentID;
                              //_selectedColor = Colors.amber;
                            });
                          },
                        );
                      }).toList(),
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
                stream: Firestore.instance.collection('Machine').document('$_selectedmachine').collection('Exercise').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Text('Loading');
                  } else{
                    return ListView(
                      children: snapshot.data.documents.map((document){
                        return ListTile(
                            dense: true,
                            selected: true,
                            enabled: true,
                            title: AutoSizeText(
                              document.documentID, style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                              maxLines: 1,
                            ),
                            onTap:(){
                              setState(() {
                                _selectedexercise = document.documentID;
                                //_selectedColor = Colors.amber;
                              });
                            }
                        );
                      }).toList(),
                    );
                  }
                }
            ),
          ),
        )
      ],
    );
  }
}
