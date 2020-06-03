import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              text: '구글로그인',
              onPressed: (){
                _handleSignIn().then((user){print(user);});
              },
            )
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async{
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))) as FirebaseUser;
    return user;
  }
}
