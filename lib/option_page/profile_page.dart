import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_t/option_page/profile_editing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();}

class _ProfilePageState extends State<ProfilePage> {
  var id;
  var nickname;
  final GoogleSignIn _googleSignIn  = GoogleSignIn();

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
      nickname = (prefs.getString('NickName') ?? '초보자');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Users').document('$id').collection('Profile').snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator()
                    ],
                  ),
                );
              }
              else{
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        //decoration: BoxDecoration(border: Border.all()),
                        child: Text(nickname.toString(), style: TextStyle(fontSize: 20),),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: 120.0,
                          height: 120.0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.photoUrl),
                          ),
                      ),
                      SizedBox(height: 10,),
                      /*Container(
                        child: Text('$id')
                      ),*/
                      Container(
                        alignment: Alignment.center,
                          width: 150,
                          height: 50,
                          child: AutoSizeText(widget.user.displayName,
                            style: TextStyle(fontSize: 25),
                            maxLines: 1,
                          )
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 330,
                                height: 30,
                                child: Text('소개', style: TextStyle(fontSize: 18),)
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(), color: Colors.white),
                              width: 340,
                              height: 200,
                              child: Text(
                                  snapshot.data.documents[0]["intro"], style: TextStyle(color: Colors.black),),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              width: 330,
                              height: 30,
                              child: Text('목표', style: TextStyle(fontSize: 18),),
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(), color: Colors.white),
                              width: 340,
                              height: 100,
                              child: Text(snapshot.data.documents[0]["target"], style: TextStyle(color: Colors.black),),
                            ),
                            Container(
                              width: 100,
                              //decoration: BoxDecoration(border: Border.all()),
                              child: RaisedButton(
                                child: Text('수정하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, ),),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){return ThemeConsumer(child: ProfileEditingPage());}));
                                },
                              ),
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              );}
            }
          )
        ),
      ),
    );
  }
  Widget _buildAppBar() {
    return AppBar(
    );
  }
}
