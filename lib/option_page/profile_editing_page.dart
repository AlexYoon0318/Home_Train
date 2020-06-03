import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditingPage extends StatefulWidget {
  @override
  _ProfileEditingPageState createState() => _ProfileEditingPageState();}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  var textEditingController_Intro = TextEditingController();
  var textEditingController_Target = TextEditingController();
  String _intro;
  String _target;
  var id;
  var _currentNickName;


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
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Users').document('$id').collection('Profile').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  //if(!snapshot.hasData){return Text('계정생성을 해주세요.');}
                  if(snapshot.data == null){
                    return CircularProgressIndicator();
                  }
                  else{
                    textEditingController_Intro.value = textEditingController_Intro.value.copyWith(text: snapshot.data.documents[0]["intro"]);
                    textEditingController_Target.value = textEditingController_Target.value.copyWith(text: snapshot.data.documents[0]["target"]);
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 80,
                              height: 50,
                              //child: Text('칭호')
                            ),
                            Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        width: 330,
                                        //height: 20,
                                        child: Text('소개', style: TextStyle(fontSize: 18),)
                                    ),
                                    Container(
                                      decoration: BoxDecoration(border: Border.all(), color: Colors.white),
                                      width: 340,
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(border: InputBorder.none, hintText: '소개글'),
                                          controller: textEditingController_Intro,
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 330,
                                      child: Text('목표', style: TextStyle(fontSize: 18),),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(border: Border.all(), color: Colors.white),
                                      width: 340,
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(border: InputBorder.none, hintText: '목표'),
                                          controller: textEditingController_Target,
                                          maxLines: null,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text('완료'),
                                      onPressed: (){
                                        _intro = textEditingController_Intro.text;
                                        _target = textEditingController_Target.text;
                                        Firestore.instance.collection('Users').document('$id').collection('Profile').document('profile').setData({
                                          'intro' : _intro,
                                          'target' : _target
                                        }, merge: true);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
            )
        ),
      ),
    );
  }
}
