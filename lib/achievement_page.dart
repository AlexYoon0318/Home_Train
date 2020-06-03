import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_t/trophies/elephant_page.dart';
import 'package:home_t/trophies/hippo_page.dart';
import 'package:home_t/trophies/rhino_page.dart';
import 'package:home_t/trophies/sharkpage.dart';
import 'package:home_t/trophies/trex_page.dart';
import 'package:home_t/trophies/whalepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('업적'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return
      StreamBuilder(
        stream: Firestore.instance.collection('Users').document('$id').collection('Profile').document('record').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator()
                ],
              ),
            );
          }else{
            int Total_weight = snapshot.data['Total_weight'];
          return Center(
            child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                      child: Total_weight >= 1500 ? Image.asset('assets/Hippo.png') : Icon(Icons.device_unknown, size: 100,),
                      onTap: (){
                        if(Total_weight >= 1500){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            Firestore.instance.collection('Users').document('$id').collection('Profile').document('record').collection('achievement').document('하마를 들어올린 자').setData({});
                            return ThemeConsumer(child:HippoPage());}));
                        }else{
                          _showWarningDialog(context);
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                      child: Total_weight >= 2300 ? Image.asset('assets/Rhino.png') : Icon(Icons.device_unknown, size: 100,),
                      onTap: (){
                        if(Total_weight >= 2300){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ThemeConsumer(child:RhinoPage());
                          }
                          )
                          );
                        }else{
                          _showWarningDialog(context);
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                      child: Total_weight >= 6000 ? Image.asset('assets/Elephant.png') : Icon(Icons.device_unknown, size: 100,),
                      onTap: (){
                        if(Total_weight >= 6000){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ThemeConsumer(child:ElephantPage());
                          }
                          )
                          );
                        }else{
                          _showWarningDialog(context);
                        }
                        }
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                        child: Total_weight >= 9000 ? Image.asset('assets/Shark.png') : Icon(Icons.device_unknown, size: 100,),
                        onTap: (){
                          if(Total_weight >= 9000){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ThemeConsumer(child:SharkPage());
                            }
                            )
                            );
                          }else{
                            _showWarningDialog(context);
                          }
                        }
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                        child: Total_weight >= 14000 ? Image.asset('assets/Trex.png') : Icon(Icons.device_unknown, size: 100,),
                        onTap: (){
                          if(Total_weight >= 14000){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ThemeConsumer(child:TrexPage());
                            }
                            )
                            );
                          }else{
                            _showWarningDialog(context);
                          }
                        }
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: InkWell(
                        child: Total_weight >= 23000 ? Image.asset('assets/Whale.png') : Icon(Icons.device_unknown, size: 100,),
                        onTap: (){
                          if(Total_weight >= 23000){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ThemeConsumer(child:WhalePage());
                            }
                            )
                            );
                          }else{
                            _showWarningDialog(context);
                          }
                        }
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
    );}
        }
      );
  }

  void _showWarningDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("자격이 충족되지 않았습니다. 더 열심히 해주세요!"),
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
