import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 300,
              //decoration: BoxDecoration(border: Border.all()),
              child: Text('상어를 들어올린 자', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 280,
              width: 280,
              child: Image.asset('assets/Shark.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 330,
              height: 120,
              //decoration: BoxDecoration(border: Border.all()),
              child: Text('상어는 연골어류에 속하는 어류이다. 커다란 고래부터 작은 플랑크톤까지 바다의 최상위 포식자로 군림한다. 성인 고래상어의 평균 몸무게는 9톤으로 당신은 지금까지 한마리의 성인 고래상어를 들어올렸습니다.'
                , style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
            ),
            RaisedButton(
              child: Text('칭호 바꾸기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, ),),
              onPressed: (){
                saveData();
              },
            )
          ],
        ),
      ),
    );
  }
  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final nickname = "상어를 들어올린 자";
    prefs.setString('NickName', nickname);
  }

  void _showWarningDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("칭호가 바뀌었습니다."),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context, "OK");
                  Navigator.of(context).pop();
                  //Navigator.of.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}
