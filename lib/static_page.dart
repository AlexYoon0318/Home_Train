import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:home_t/data/Static/exercise_info.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StaticPage extends StatefulWidget {
  @override
  _StaticPageState createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  DateTime _time;
  Map<String, num> _measures;
  _onSelectionChanged(charts.SelectionModel model){
    final selectedDatum = model.selectedDatum;
    ExerciseInfo exerciseInfo;
    DateTime C1 = exerciseInfo.C1.toDate();
    final measures = <String, num>{};
    if(selectedDatum.isNotEmpty){
      C1 = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.exerciseinfo;
      });
    }
    setState(() {
      _time = C1;
      _measures = measures;
    });
  }

  var selectedmachine, selectedType;
  var selectedexercise, selectedType2;
  var id;

  List<ExerciseInfo> mydata_weight;
  List<ExerciseInfo> mydata_volume;
  List<charts.Series<ExerciseInfo, DateTime>> _seriesList;

  _generateData(mydata_weight, mydata_volume) {
    _seriesList = List<charts.Series<ExerciseInfo, DateTime>>();
    _seriesList.add(
      charts.Series(
        domainFn: (ExerciseInfo exerciseinfo, _) => exerciseinfo.C1.toDate(),
        measureFn: (ExerciseInfo exerciseinfo, _) => exerciseinfo.RMweight,
        id: 'ExerciseGraph',
        data: mydata_weight,
        labelAccessorFn: (ExerciseInfo row, _) => "${row.C1}",
      ),
    );
    _seriesList.add(
      charts.Series(
        domainFn: (ExerciseInfo exerciseinfo, _) => exerciseinfo.C1.toDate(),
        measureFn: (ExerciseInfo exerciseinfo, _) => exerciseinfo.Volume/100,
        id: 'ExerciseGraph',
        data: mydata_volume,
        labelAccessorFn: (ExerciseInfo row, _) => "${row.C1}",
      ),
    );
  }

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
    return
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('통계'),
        ),
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _Select(),
                  _buildbody(context),
                  _information(context),
                ],
              ),
            )
        ),
    );
  }


  Widget _buildbody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collectionGroup('Info')
          .where('id', isEqualTo: id)
          .where('machine', isEqualTo: selectedmachine)
          .where('exercise', isEqualTo: selectedexercise)
          .snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white
            ),
          );
        }
        if(selectedexercise  == null){
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                width: 340,
                decoration: BoxDecoration(color: Colors.white),
                height: 310,
              ),
              SizedBox(
                height:10
              )
            ],
          );
        }
        else {
          List<ExerciseInfo> exerciseinfo = snapshot.data.documents.map((documentSnapshot) => ExerciseInfo.fromMap(documentSnapshot.data)).toList();
          //exerciseInfo = snapshot.data.documents.map((documentSnapshot) => ExerciseInfo.fromMap(documentSnapshot.data));
          return _buildChart(context, exerciseinfo);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ExerciseInfo> exerciseinfo) {
    mydata_weight = exerciseinfo;
    mydata_volume = exerciseinfo;
    _generateData(mydata_weight, mydata_volume);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(), color: Colors.white),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 300.0,
                child:
                charts.TimeSeriesChart(
                  _seriesList,
                  animate: true,
                  /*selectionModels: [
                    charts.SelectionModelConfig(
                      type: charts.SelectionModelType.info,
                      //changedListener: _onSelectionChanged,
                      //updatedListener: _onSelectionChanged,
                    )
                  ],*/
                  animationDuration: Duration(milliseconds: 500),
                  behaviors: [
                    charts.LinePointHighlighter(
                        showHorizontalFollowLine:
                        charts.LinePointHighlighterFollowLineType.none,
                        showVerticalFollowLine:
                        charts.LinePointHighlighterFollowLineType.nearest
                    ),
                    charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Select() {
    return
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
                              style: TextStyle(color: Color(0xff11b719)),
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
                        hint: AutoSizeText('운동기구', style: TextStyle(fontSize: 12.0),),
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
                    stream: Firestore.instance
                        .collection('Users')
                        .document('$id')
                        .collection('Machine')
                        .document('$selectedmachine').collection('exercise').snapshots(),
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
                                child:AutoSizeText(
                                  snap.documentID,
                                  style: TextStyle(fontSize:12, color: Color(0xff11b719)),
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
                                hint: Text('운동'),
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
      );
  }

  Widget _information(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:16.0),
      child: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder/*<QuerySnapshot>*/(
                stream: Firestore.instance
                    .collectionGroup('Info').where('id', isEqualTo: id)
                    .where('exercise', isEqualTo: selectedexercise)
                    .where('machine', isEqualTo: selectedmachine)
                    .orderBy('RMweight', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container(child: Text(' '),);
                  }
                  if(selectedexercise == null){
                    return Row(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color:Colors.black26,
                                borderRadius:
                                BorderRadius.only(
                                    topLeft: Radius.circular(20)
                                )
                            ),
                            child: Text('1RM', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                        Container(
                            width: 220,
                            alignment: Alignment.centerLeft,
                            height:40,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color:Colors.white70,
                                borderRadius:
                                BorderRadius.only(
                                    topRight: Radius.circular(20)
                                )
                            ),
                            child: Text('  ', style: TextStyle(fontSize: 17),)),
                      ],
                    );
                  }
                  else{
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    return Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(),
                              color:Colors.black26,
                              borderRadius:
                              BorderRadius.only(
                                  topLeft: Radius.circular(20)
                              )
                          ),
                            child: Text('1RM', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                        Container(
                            width: 220,
                            alignment: Alignment.centerLeft,
                            height:40,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color:Colors.white70,
                                borderRadius:
                                BorderRadius.only(
                                    topRight: Radius.circular(20)
                                )
                            ),
                            child: Text('  ${items[0]['RMweight']}kg', style: TextStyle(fontSize: 17),)),
                      ],
                    );
                  }
                }
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collectionGroup('Info').where('id', isEqualTo: id)
                    .where('exercise', isEqualTo: selectedexercise)
                    .where('machine', isEqualTo: selectedmachine)
                    .orderBy('Volume', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container(child: Text(' '),);
                  }
                  if(selectedexercise == null){
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.black26,
                                ),
                                child: Text('최대볼륨', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)
                            ),
                            Container(
                                width: 220,
                                alignment: Alignment.centerLeft,
                                height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.white70,
                                ),
                                child: Text('  ', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.black26,
                                ),
                                child: Text('평균볼륨', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                            Container(
                                width: 220,
                                alignment: Alignment.centerLeft,
                                height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.white70,
                                ),
                                child: Text('  ', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color:Colors.black26,
                                    borderRadius:
                                    BorderRadius.only(
                                        bottomLeft: Radius.circular(20)
                                    )
                                ),
                                child: Text('시행횟수', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                            Container(
                                width: 220,
                                alignment: Alignment.centerLeft,
                                height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color:Colors.white70,
                                    borderRadius:
                                    BorderRadius.only(
                                        bottomRight: Radius.circular(20)
                                    )
                                ),
                                child: Text('  ', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                      ],
                    );
                  }
                  else{
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    var result = items.map((m)=>m['Volume']).reduce((a,b)=>a+b)/snapshot.data.documents.length;
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color:Colors.black26,
                              ),
                                child: Text('최대볼륨', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)
                            ),
                            Container(
                              width: 220,
                              alignment: Alignment.centerLeft,
                              height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.white70,
                                ),
                                child: Text('  ${items[0]['Volume']}kg', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.black26,
                                ),
                                child: Text('평균볼륨', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                            Container(
                                width: 220,
                                alignment: Alignment.centerLeft,
                                height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                  color:Colors.white70,
                                ),
                                child: Text('  ${result.round()}kg', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color:Colors.black26,
                                    borderRadius:
                                    BorderRadius.only(
                                        bottomLeft: Radius.circular(20)
                                    )
                                ),
                                child: Text('시행횟수', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)),
                            Container(
                                width: 220,
                                alignment: Alignment.centerLeft,
                                height:40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    color:Colors.white70,
                                    borderRadius:
                                    BorderRadius.only(
                                        bottomRight: Radius.circular(20)
                                    )
                                ),
                                child: Text('  ${snapshot.data.documents.length}', style: TextStyle(fontSize: 17),)),
                          ],
                        ),
                      ],
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}