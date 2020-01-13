import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configure extends StatefulWidget {
  @override
  _ConfigureState createState() => _ConfigureState();
}

class _ConfigureState extends State<Configure> {
  TextEditingController textEditingController =  new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getEmail();
    super.initState();
  }


  _getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = await prefs.get('email');
    if(email != null)
      setState(() {
        textEditingController.text = email;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure HI-FI"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(labelText: "Email"),
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                child: Text("Save"),
                onPressed: (){
                  print(textEditingController.text);
                  _saveEmail(textEditingController.text);
                },
              ))
        ],
      ),
    );
  }

  _saveEmail(email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }


}