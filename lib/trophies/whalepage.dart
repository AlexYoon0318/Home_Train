import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhalePage extends StatelessWidget {
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
              child: Text('고래를 들어올린 자', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 280,
              width: 280,
              child: Image.asset('assets/Whale.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 330,
              height: 120,
              //decoration: BoxDecoration(border: Border.all()),
              child: Text('고래는 고래하목에 속하는 포유류의 총칭으로, 매우 큰 해양 포유동물이다. 남방참고래의 평균 몸무게는 2.3톤으로 당신은 지금까지 한마리의 남방참고래를 들어올렸습니다.'
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
    final nickname = "고래를 들어올린 자";
    prefs.setString('NickName', nickname);
  }
}
