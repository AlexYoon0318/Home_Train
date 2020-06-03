import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElephantPage extends StatelessWidget {
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
              child: Text('코끼리를 들어올린 자', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 280,
              width: 280,
              child: Image.asset('assets/Elephant.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 330,
              height: 120,
              //decoration: BoxDecoration(border: Border.all()),
              child: Text('코끼리는 장비목에서 유일하게 현존하는 과인 코끼리과를 구성하는 동물들의 총칭으로, 현생 육상동물 가운데서는 가장 몸집이 크다. 아프리카 코끼리의 평균 몸무게는 6톤으로 당신은 지금까지 아프리카 코끼리를 한마리 들어올렸습니다.'
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
    final nickname = "코끼리를 들어올린 자";
    prefs.setString('NickName', nickname);
  }
}
