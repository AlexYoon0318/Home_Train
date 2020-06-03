import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_t/data/Static/calendar_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarPage extends StatefulWidget {
  final String title;
  const CalendarPage({Key key, this.title}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  Color _selectedColor = Colors.white12;

  Stream<QuerySnapshot> eventstream;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<Marker>> _markers;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  String a1;

  var id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadID();
    _events = {
    };
    _markers = {};
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }


  _loadID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = (prefs.getString('UID') ?? 0);
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    _calendarController.dispose();
  }


  void _onVisibleDaysChanged(DateTime first, DateTime last,
      CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<String, dynamic> decodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('달력'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            SizedBox(height: 10.0),
            Expanded(
                child: _buildEventList())
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      initialSelectedDay: DateTime.now(),
      initialCalendarFormat: CalendarFormat.week,
      calendarController: _calendarController,
      holidays: _markers,
      calendarStyle:
      CalendarStyle(
        //weekdayStyle: TextStyle(color:Colors.grey),
        selectedColor: Colors.purple[300],
        todayColor: Colors.blueGrey[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
          formatButtonTextStyle: TextStyle().copyWith(
              color: Colors.white, fontSize: 45.0),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepOrange[400],
            borderRadius: BorderRadius.circular(16.0),
          ),
          titleTextStyle: TextStyle(color:Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
          formatButtonVisible: false
      ),
      onDaySelected: (date, events){
        var D = date.toString();
        setState(() {
          _selectedEvents = events;
          eventstream = Firestore.instance.collection('Users').document('$id').collection('Exercise')
              .document('$D')
              .collection('detail')
              .where("day", isEqualTo: date.toString())
              .orderBy('C1')
              //.where('PF', isGreaterThanOrEqualTo: 0)
              .snapshots();
        });
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }
          return children;
        }
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: eventstream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('');
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
            /*builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting: return Container();
                default:
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  return ListView(
                    children: snapshot.data.documents.map((document) {
                      if(document['PF'] == true){
                        _selectedColor = Colors.lightGreenAccent;
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
                              border: Border(bottom: BorderSide(color: Colors.black),),
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
                                    AutoSizeText(document["machine"],
                                      textAlign: TextAlign.center,
                                      minFontSize: 1,
                                      maxLines: 1,
                                      style:
                                      TextStyle(
                                          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15
                                      ),
                                    ),
                                    AutoSizeText(document["exercise"],
                                      textAlign: TextAlign.center,
                                      minFontSize: 1,
                                      maxLines: 1,
                                      style:
                                      TextStyle(
                                          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15
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
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                    /*
                    ListView(
                      children: documents.map((eachDocument)=>CalendarView(eachDocument)).toList());*/
              }
            }*/
        ),
      ),
    );
  }



  Widget _buildEventsMarker(DateTime date, List<Marker> marker) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Exercise').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Container(child:Text('휴식'));
        }
        else{
          List<Marker> marker = snapshot.data.documents.map((documentSnapshot) => Marker.fromMap(documentSnapshot.data)).toList();
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: _calendarController.isSelected(date) ? Colors.brown[500]
                  : _calendarController.isToday(date) ? Colors.red[700] : Colors.red[400],
            ),
            width: 16.0,
            height: 16.0,
            child: Center(
              child: Text(
                '${marker.length}',
                style: TextStyle().copyWith(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}