import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {

  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(fontSize: 40.0, fontFamily: "Bebas Neue", );
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class SecondaryExercisePage extends StatefulWidget {
  SecondaryExercisePage({Key key, this.dependencies}) : super(key: key);

  final Dependencies dependencies;
  @override
  _SecondaryExercisePageState createState() => _SecondaryExercisePageState();
}

class _SecondaryExercisePageState extends State<SecondaryExercisePage> {

  Color _selectedColor = Colors.blue;

  final Dependencies dependencies = new Dependencies();

  var exercise_date = DateTime.now().toString();
  final b1 = (' 12:00:00.000Z');
  final a1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime c1 = DateTime.now();

  int setCounter = 1;
  int SetCount;
  var _set;
  var _exercise;
  var _machine;
  var _count;
  var name;
  int _weight=0;
  int _weight2=0;
  int RMweight;
  int _volume=0;
  int _volume2=0;
  int RMvolume;
  var T = DateTime.now();
  var nfcName;
  var test;
  var id;
  int Total_weight = 0;
  var Total_weight2;
  int Total_weight3;

  var currentStream;
  //ScrollController _scrollController;

  /*_moveDown(){
    _scrollController.animateTo(_scrollController.offset + 50, duration: Duration(milliseconds: 500), curve: Curves.linear);
  }*/
  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("beep01.mp3");
  }


  @override
  void initState() {
    //_scrollController = ScrollController();
    super.initState();
    _loadID();
    playLocalAsset();
    FlutterNfcReader.onTagDiscovered().listen((value){
      nfcName =  value.content.substring(4);
      dependencies.stopwatch.reset();
      setState(() {
        if(nfcName == _machine){
        setCounter = setCounter+1;
        playLocalAsset();
        _nfc_tag();
        }
      });
    });
  }


  _loadID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = (prefs.getString('UID') ?? 0);
    });
  }

  _loadTotal_weight() async{
    setState(() {
        Firestore.instance.collection('Users').document('$id').collection('Profile').document('record').snapshots().listen((doc){
          if(doc.exists){
            Total_weight2 = doc['Total_weight'];
          }else{
            Total_weight2 = 0;}
        }
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    var D = a1+b1;
    return SafeArea(
      child: Scaffold(
          //backgroundColor: Colors.white12,
          body:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        //border: Border.all()
                      ),
                        child: Column(
                          children: <Widget>[
                            _current_exercise(),
                            TimerText(dependencies: dependencies),
                          ],
                        )
                    ),
                    Container(height: 100,),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 180,
                    child: _exercise_list()),
                ///버튼
                Container(
                  height: 80,
                  decoration:BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          child:RaisedButton(
                            child: Text('완료', style: TextStyle(fontSize: 18),),
                            onPressed: (){
                              _loadTotal_weight();
                              playLocalAsset();
                              setState(() {
                                Total_weight = Total_weight+(_weight * _count);
                                dependencies.stopwatch.reset();
                                setCounter = setCounter + 1;
                                nfcName = null;
                                if(setCounter == _set + 1){
                                  Firestore.instance.collection('Users').document('$id')
                                      .collection('Exercise')
                                      .document('$D')
                                      .collection('detail')
                                      .orderBy('C1')
                                      .where('PF',isNull: true)
                                      .limit(1)
                                      .getDocuments()
                                      .then((snapshot){for(DocumentSnapshot ds in snapshot.documents)
                                    ds.reference.updateData({'PF':true});
                                  }
                                  );
                                  Firestore.instance
                                      .collection('Users')
                                      .document('$id')
                                      .collection('Exercise')
                                      .document('$D')
                                      .collection('Info')
                                      .document('$name').get().then((DocumentSnapshot ds) {
                                                _weight2 = ds['RMweight'];
                                                _volume2 = ds['Volume'];
                                              });
                                  final doc = Firestore.instance
                                      .collection('Users')
                                      .document('$id')
                                      .collection('Exercise')
                                      .document('$D')
                                      .collection('Info')
                                      .document('$name');
                                  if(_weight >= _weight2){
                                    RMweight = _weight;
                                  }
                                  else{RMweight = _weight2;}
                                  if(_volume >= _volume2){
                                    RMvolume = _volume;
                                  }
                                  else{RMvolume = _volume2;}
                                  doc.setData({
                                    'id' : id,
                                    'C1' : T,
                                    'machine':_machine,
                                    'exercise':_exercise,
                                    'RMweight': RMweight,
                                    'Volume': RMvolume
                                  }, merge: true);
                                  setCounter = 1;
                                  nfcName = null;
                                  //_moveDown();
                                }
                              });
                            },
                          )
                      ),
                      Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all()
                          ),
                          child:RaisedButton(
                            child: Text('실패', style: TextStyle(fontSize: 18),),
                            onPressed: (){
                              playLocalAsset();
                              Firestore.instance.collection('Users').document('$id')
                                  .collection('Exercise')
                                  .document('$D')
                                  .collection('detail')
                                  .orderBy('C1')
                                  .where('PF', isNull: true)
                                  .limit(1)
                                  .getDocuments()
                                  .then((snapshot){for(DocumentSnapshot ds in snapshot.documents)
                                ds.reference.updateData({'PF':false});
                              setState(() {
                                dependencies.stopwatch.reset();
                                setCounter = 1;
                              });
                              }
                              );
                            },
                          )
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _current_exercise() {
    final D = a1+b1;
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('Users').document('$id')
            .collection('Exercise')
            .document('$D')
            .collection('detail')
            .where('PF', isNull: true)
            .orderBy('C1')
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          else{
            List<DocumentSnapshot> items = snapshot.data.documents;
            if(items.length == 0){
              Total_weight3 = Total_weight + Total_weight2;
              Future.delayed(Duration(seconds: 3), () {
                if(this.mounted){
                  setState(() {
                    Firestore.instance.collection('Users').document('$id').collection('Profile').document('record').setData({'Total_weight' : Total_weight3}, merge: true);
                    Navigator.of(context).pop();
                  });
              }});
              return Text('운동끝', style: TextStyle(
                  //color: Colors.white
              ),
              );
            }else{
              _set = items[0]["set"];
              _machine = items[0]["machine"];
              _exercise = items[0]["exercise"];
              _volume =items[0]["Volume"];
              _weight = items[0]["weight"];
              _count = items[0]["count"];
              name = _machine+_exercise;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Container(
                    child: Text('$setCounter / $_set',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          //color: Colors.white70,
                          fontFamily: 'Oswald'),
                    )
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 270,
                  child: AutoSizeText('$_machine $_exercise',
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 32,
                        //color: Colors.white70,
                        fontFamily: 'BlackHanSans'),
                  ),
                ),
                LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  width: 250.0,
                  animation: true,
                  animationDuration: 0,
                  lineHeight: 20.0,
                  percent: setCounter/_set,
                  //center: Text("$setCounter/$_set"),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.deepOrange,
                ),
              ],
            );
            }
          }
        },
      )
    );
  }

  Widget _exercise_list() {
    final D = a1+b1;
    return Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('Users').document('$id')
              .collection('Exercise')
              .document('$D')
              .collection('detail')
              .where('PF', isNull: true)
              .orderBy('C1')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading...');
            }else{
              return ListView(
                //controller: _scrollController,
                children: snapshot.data.documents.map((document) {
                  if(document['PF'] == true){
                    _selectedColor = Colors.green;
                  }
                  if(document['PF']==false){
                    _selectedColor = Colors.red;
                  }
                  if(document['PF']==null){
                    _selectedColor = Colors.black26;
                  }
                  return ListTile(
                    dense: true,
                    title: Container(
                      decoration:
                      BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black),top:BorderSide(color : Colors.black)),
                        color: _selectedColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //운동이름
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 110,
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                AutoSizeText(
                                  document["machine"],
                                  textAlign: TextAlign.center,
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15
                                  ),
                                ),
                                AutoSizeText(document["exercise"],
                                  textAlign: TextAlign.center,
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15
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
                                //border: Border.all(),
                                //color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("무게",
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15
                                  ),),
                                Text(document["weight"].toString(),
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
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
                                //border: Border.all(),
                                //color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("개수",
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15
                                  ),),
                                Text(document["count"].toString(),
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold
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
                                //border: Border.all(),
                                //color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("세트",
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15
                                  ),
                                ),
                                Text(document["set"].toString(),
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        )
    );
  }

  _nfc_tag(){
    _loadTotal_weight();
    var D = a1+b1;
    Total_weight = Total_weight+(_weight * _count);
      if(setCounter == _set + 1){
        Firestore.instance.collection('Users').document('$id')
            .collection('Exercise')
            .document('$D')
            .collection('detail')
            .orderBy('C1')
            .where('PF',isNull: true)
            .limit(1)
            .getDocuments()
            .then((snapshot){for(DocumentSnapshot ds in snapshot.documents)
          ds.reference.updateData({'PF':true});
        }
        );
        Firestore.instance.collection('Users').document('$id').collection('Exercise').document('$D').collection('Info').document('$name').get().then((DocumentSnapshot ds) {
          _weight2 = ds['RMweight'];
          _volume2 = ds['Volume'];
        });
        final doc = Firestore.instance.collection('Users').document('$id').collection('Exercise').document('$D').collection('Info').document('$name');
        if(_weight >= _weight2){
          RMweight = _weight;
        }
        else{RMweight = _weight2;}
        if(_volume >= _volume2){
          RMvolume = _volume;
        }
        else{RMvolume = _volume2;}
        doc.setData({
          'id' : id,
          'C1' : T,
          'machine':_machine,
          'exercise':_exercise,
          'RMweight': RMweight,
          'Volume': RMvolume
        }, merge: true);
        setCounter = 1;
        nfcName = null;
      }
  }
  }



class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() => new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate), callback);
    Timer(Duration(seconds: 0), (){
      dependencies.stopwatch.start();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
    dependencies.stopwatch.elapsedMilliseconds;

  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new Hundreds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() => new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}