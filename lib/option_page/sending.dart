import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendingPage extends StatelessWidget {
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('의견 보내기')),
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 340,
                  alignment: Alignment.centerLeft,
                  //decoration: BoxDecoration(border: Border.all()),
                  child: Text('의견', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),textAlign: TextAlign.center,),
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(), color: Colors.white),
                width: 340,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(border: InputBorder.none, hintText: '의견'),
                    controller: _bodyController,
                    maxLines: null,
                  ),
                ),
              ),
              RaisedButton(
                child: Text('의견 제출'),
                //color: Colors.red,
                onPressed: (){
                  _showWarningDialog(context);
                  Firestore.instance.collection('Opinion').document().setData({'opinion' : _bodyController.text});}
              ),
            ],
          )),
    );
  }


  void _showWarningDialog(BuildContext context) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("의견이 등록되었습니다."),
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

