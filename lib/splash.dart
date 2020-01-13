import 'dart:async';
import 'package:hifi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  double logoWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Material(
        child: Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xfffffde7), Color(0xffffffff)])),
            child: Center(
                child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              onEnd: () {
                setState(() {
                  logoWidth = logoWidth == 160 ? 145.0 : 160;
                });
              },
              curve: Curves.easeInOut,
              width: logoWidth,
              child: Image(
                image: AssetImage("assets/logo.png"),
              ),
            ))),
        Positioned(
          bottom: 10,
          width: _width,
          child: Text("Qubits IT services @ 2020 ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
//                    fontFamily: "PoiretOne",
                fontWeight: FontWeight.w100,
                color: Colors.black54,
              )),
        )
      ],
    ));
  }

  startTimer() async {
    var _duration = Duration(milliseconds: 500);
    return Timer(_duration, navigate);
  }

  _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get('email');
  }

  navigate() async {
    var email = await _getEmail();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
}
