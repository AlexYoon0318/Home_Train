import 'package:flutter/material.dart';

class NFCInstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC 등록하기'),
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
                        child: Image.asset('assets/1.png')),
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
                    Text('2.NFC에 등록하고자 하는 운동기구를 선택한 후 "NFC등록"버튼을 누릅니다.'),
                    Container(
                        child: Image.asset('assets/5.png')),
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
                    Text('3.기기를 NFC칩에 접촉시킵니다.'),
                    Container(
                        child: Image.asset('assets/6.png')),
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
                    Text('4.NFC가 등록된 후 NFC완료창을 닫습니다.'),
                    /*Container(
                        child: Image.asset('assets/1.png')),*/
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
