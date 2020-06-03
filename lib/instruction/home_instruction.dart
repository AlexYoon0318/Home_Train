import 'package:flutter/material.dart';
import 'package:home_t/instruction/begin_instruction.dart';
import 'package:home_t/instruction/nfc_tag_instruction.dart';
import 'package:home_t/instruction/page_instruction.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeInstruction extends StatefulWidget {
  @override
  _HomeInstructionState createState() => _HomeInstructionState();
}

class _HomeInstructionState extends State<HomeInstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('어플 사용방법'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text('운동 시작하기', textAlign: TextAlign.center,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: BeginInstructionPage())));
              }
          ),
          ListTile(
              title: Text('NFC 등록하기', textAlign: TextAlign.center,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: NFCInstructionPage())));
              }
          ),
          /*ListTile(
              title: Text('페이지 설명', textAlign: TextAlign.center,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ThemeConsumer(child: PageInstructionPage())));
              }
          ),*/
        ],
      ),
    );
  }
}
