import 'package:flutter/material.dart';

class BeginInstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 시작하기'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 340,
              //decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('1.옵션페이지의 "운동관리 페이지"를 엽니다.'),
                    Container(
                        child: Image.asset('assets/11.png')),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
            ),
            Container(
                width: 340,
                //decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('2.운동기구와 해당기구로 하는 운동을 등록합니다.'),
                    Container(
                        child: Image.asset('assets/22.png')),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
            ),
            Container(
                width: 340,
                //decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  children: <Widget>[
                    Text('3.기본페이지의 하단에 있는 "운동시작"버튼을 누릅니다.'),
                    Container(
                        child: Image.asset('assets/3.png')),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
            ),
            Container(
                width: 340,
                //decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  children: <Widget>[
                    Text('4.운동기구와 운동을 선택한 후 나에게 맞는 무게/개수/세트를 선택한 후 "추가하기"를 눌러 운동계획을 추가합니다.'),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
            ),
            Container(
                width: 340,
                //decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Column(
                  children: <Widget>[
                    Text('5.계획을 모두 추가한 후 "운동시작"버튼을 눌러 운동을 시작합니다.'),
                    SizedBox(
                      height: 20,
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
