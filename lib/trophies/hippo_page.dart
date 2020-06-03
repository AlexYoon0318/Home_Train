import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HippoPage extends StatelessWidget {
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
              child: Text('하마를 들어올린 자', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 280,
              width: 280,

              child: Image.asset('assets/Hippo.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 330,
              height: 120,
              //decoration: BoxDecoration(border: Border.all()),
              child: Text('하마는 우제목 하마과의 포유류로 코끼리와 흰 코뿔소 다음으로 큰 대형 육상동물이다. 하마의 평균 몸무게는 1.5 ~ 1.8톤으로 당신은 지금까지 한마리의 하마를 들어올렸습니다.'
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
    final nickname = "하마를 들어올린 자";
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
