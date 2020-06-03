import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_t/login_page.dart';
import 'package:home_t/tab_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          getData();
          return TabPage(snapshot.data);
        } else{
          return LoginPage();
        }
      },
    );
  }
  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    prefs.setString('UID', uid);
  }
}
