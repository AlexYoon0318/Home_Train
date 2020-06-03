import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_t/option_page/adding_exercise.dart';
import 'package:home_t/instruction/home_instruction.dart';
import 'package:home_t/option_page/profile_page.dart';
import 'package:home_t/option_page/sending.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class OptionPage extends StatefulWidget {
  final FirebaseUser user;
  OptionPage(this.user);

  @override
  _OptionPageState createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
        title: Text('설정'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text('프로필 관리', textAlign: TextAlign.center,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: ProfilePage(widget.user))));
                }
            ),
            ListTile(
                title: Text('운동 관리', textAlign: TextAlign.center,),
                onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: AddingExercise())));
                }
            ),
            ListTile(
                title: Text('테마설정', textAlign: TextAlign.center,),
                onTap: (){
                  showDialog(context: context, builder: (_)=>ThemeConsumer(child: ThemeDialog(),));
                }
            ),
            ListTile(
                title: Text('어플 사용방법', textAlign: TextAlign.center,),
                onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: HomeInstruction())));
                }
            ),
            ListTile(
            title: Text('의견 보내기', textAlign: TextAlign.center,),
              onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: SendingPage())));
              }
          ),
          ],
        )
    );
  }
}