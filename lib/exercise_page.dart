import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_t/widgets/exercise_loading.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

int _currentWeight = 0;
int _currentSet =  1;
int _currentCount = 1;

class _ExercisePageState extends State<ExercisePage> {
  Stream<QuerySnapshot> eventStream;
  var id;
  ScrollController _scrollController;
  var selectedmachine, selectedType;
  var selectedexercise, selectedType2;
  int _count = 1;
  var PF;

  final b1 = (' 12:00:00.000Z');
  final a1 = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
      appBar: AppBar(title: Text('오늘의 운동계획'),),
      body: Container(
        height: 360,
        child: _showExercise(),
      ),
      floatingActionButton:
        Container(
          child: Stack(
            children: <Widget>[
              _settingExercise(),
              Container(
                alignment: Alignment.bottomCenter,
                width:800,
                height:180,
                child: FittedBox(
                  child: Row(
                    children: <Widget>[
                      FloatingActionButton.extended(
                        //backgroundColor: Colors.purple[300],
                        label: Text('추가하기'),
                          heroTag: null,
                          onPressed: () {
                            final D = a1+b1;
                            var c1 = DateTime.now();
                            final doc = Firestore.instance.collection('Users').document('$id')
                                .collection('Exercise')
                                .document('$D').collection('detail').document();
                            if(selectedexercise == null){
                              _showAlertDialog(context);
                            }
                            else{
                              _addNewExerciseRow();
                              doc.setData({
                                 'Name' : selectedmachine+selectedexercise,
                                 'machine': selectedmachine,
                                 'exercise':selectedexercise,
                                 'day': (a1+b1),
                                 'weight': _currentWeight,
                                 'count': _currentCount,
                                 'set': _currentSet,
                                 'PF': PF,
                                 'C1' : c1,
                                 'Volume' : _currentSet * _currentCount * _currentWeight,
                              });
                              _currentSet = 1;
                              _currentCount = 1;
                              _currentWeight = 0;
                              selectedmachine = null;
                              selectedexercise = null;
                            }
                          },
                        ),
                      SizedBox(width: 50,),
                      FloatingActionButton.extended(
                        //backgroundColor: Colors.purple[300],
                        heroTag: null,
                        label: Text('운동시작'),
                        onPressed: () {
                          Firestore.instance.collection('Users').document('$id').collection('Profile').document('record2').setData({'Total_weight' : 0}, merge: true);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {return ThemeConsumer(child: ExerciseLoading());}));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  void _addNewExerciseRow() {
    setState(() {
      _count = _count + 1;
    });
  }


  Widget _settingExercise() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1200,
        height: 180,
        decoration:
        BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[600]
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                        width: 15,
                        height:5
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child:StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('Users').document('$id').collection('Machine').snapshots(),
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return Text('Loading');
                            }
                            else{
                              List<DropdownMenuItem> ExerciseType = [];
                              for(int i=0;i<snapshot.data.documents.length;i++){
                                DocumentSnapshot snap = snapshot.data.documents[i];
                                ExerciseType.add(
                                    DropdownMenuItem(
                                      child:Text(
                                        snap.documentID,
                                        //style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                                      ),
                                      value: "${snap.documentID}",
                                    )
                                );
                              }
                              return Container(
                                child: DropdownButton(
                                  isExpanded: false,
                                  items: ExerciseType,
                                  onChanged: (machineValue){
                                    setState(() {
                                      selectedmachine = machineValue;
                                      selectedexercise = null;
                                    });
                                  },
                                  value: selectedmachine,
                                  isDense: false,
                                  hint: Text('운동기구',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        //color: Colors.white
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 15,
                        height:5
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('Users').document('$id').collection('Machine')
                                  .document('$selectedmachine')
                                  .collection('exercise')
                                  .snapshots(),
                              builder: (context, snapshot){
                                if(!snapshot.hasData){
                                  return Text('Loading');
                                }
                                else{
                                  List<DropdownMenuItem> ExerciseType = [];
                                  for(int i=0;i<snapshot.data.documents.length;i++){
                                    DocumentSnapshot snap = snapshot.data.documents[i];
                                    ExerciseType.add(
                                        DropdownMenuItem(
                                          child:Text(
                                            snap.documentID,
                                          ),
                                          value: "${snap.documentID}",
                                        )
                                    );
                                  }
                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          items: ExerciseType,
                                          onChanged: (exerciseValue){
                                            setState(() {
                                              selectedexercise = exerciseValue;
                                            });
                                          },
                                          value: selectedexercise,
                                          isDense: false,
                                          hint: Text('운동',
                                            style: TextStyle(
                                                //color: Colors.white,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: <Widget>[
                            Text('무게', style: TextStyle(color: Colors.white),),
                            SizedBox(
                              width: 100,
                              child: RaisedButton(
                                child: Text('$_currentWeight''kg'),
                                onPressed: _showWeightDialog,),
                            )
                          ],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Text('개수', style: TextStyle(color: Colors.white),),
                          SizedBox(
                            width: 100,
                            child: RaisedButton(
                              child: Text('$_currentCount개'),
                              onPressed: _showCountDialog,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Text('세트', style: TextStyle(color: Colors.white),),
                          SizedBox(
                            width: 100,
                            child: RaisedButton(
                              //color: Colors.,
                              child: Text('$_currentSet세트'),
                              onPressed: _showSetDialog,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showExercise() {
    final D = a1+b1;
    return StreamBuilder(
      stream: Firestore.instance.collection('Users').document('$id').collection('Exercise').document('$D').collection('detail').orderBy('C1').where('PF', isNull: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading...');
        }else{
          return ListView(
            shrinkWrap: false,
            children: snapshot.data.documents.map((document) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                resizeDuration: Duration(milliseconds: 300),
                key: UniqueKey(),
                onDismissed: (direction){
                  var D = a1+b1;
                  Firestore.instance.collection('Users').document('$id').collection('Exercise').document('$D').collection('detail').document(document.documentID).delete();
                },
                background: Container(
                  decoration: BoxDecoration(
                      color: Colors.red
                  ),
                ),
                child: ListTile(
                  dense: true,
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //운동이름
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 110,
                          decoration
                              :BoxDecoration(
                              border: Border.all(),
                              color:Colors.black26,
                              borderRadius:
                              BorderRadius.only(
                                  topLeft: Radius.circular(20)
                              )
                          ),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(document["machine"],
                                textAlign: TextAlign.center,
                                minFontSize: 1,
                                maxLines: 1,
                                style:
                                TextStyle(
                                    //color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                              AutoSizeText(document["exercise"],
                                textAlign: TextAlign.center,
                                minFontSize: 1,
                                maxLines: 1,
                                style:
                                TextStyle(
                                    //color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                            ],
                          ),
                        ),
                        //무게
                        Container(
                          width: 50,
                          height: 50,
                          decoration:
                          BoxDecoration(
                              border: Border.all(),
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("무게",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15
                                ),),
                              Text(document["weight"].toString(),
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                  color: Colors.grey, fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                        ),
                        //개수
                        Container(
                          height:50,
                          width: 50,
                          decoration:
                          BoxDecoration(
                              border: Border.all(),
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("개수",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15
                                ),),
                              Text(document["count"].toString(),
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        //세트
                        Container(
                          height: 50,
                          width: 50,
                          decoration:
                          BoxDecoration(
                              border: Border.all(),
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("세트",
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15
                                ),
                              ),
                              Text(document["set"].toString(),
                                textAlign: TextAlign.center,
                                style:
                                TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.only(
                                    bottomRight: Radius.circular(20)
                                )
                            ),
                            height: 50,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: (){},
                            )
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  void _showWeightDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 300,
            step: 5,
            title: Text("무게를 설정해주세요."),
            initialIntegerValue: _currentWeight,
          );
        }
    ).then((int Value) {
      if (Value != null) {
        setState(() => _currentWeight = Value
        );
      }
    });
  }

  void _showCountDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 300,
            title: Text("개수를 설정해주세요."),
            initialIntegerValue: _currentCount,
          );
        }
    ).then((onValue) {
      if (onValue != null) {
        setState(() => _currentCount = onValue,
        );
      }
    });
  }

  void _showSetDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 300,
            title: Text("세트수를 설정해주세요."),
            initialIntegerValue: _currentSet,
          );
        }
    ).then((onValue) {
      if (onValue != null) {
        setState(() => _currentSet = onValue
        );
      }
    });
  }

  void _showAlertDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("운동기구 혹은 운동종류를 표시해주세요."),
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

  void _showAlertDialog2(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("운동을 계획해주세요."),
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