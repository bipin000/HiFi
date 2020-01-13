import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hifi/configure.dart';
import 'package:hifi/google_login.dart';
import 'package:hifi/splash.dart';
import 'package:hifi/stats.dart';
import 'dart:io';
import "package:hifi/comman.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;

var time = DateTime.now().millisecondsSinceEpoch;
var today = DateTime.now().weekday;
var apiUrl = "http://glue.is/da.php?time=" + time.toString();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          backgroundColor: Color(0xff2d3138),
          scaffoldBackgroundColor: Color(0xff2e0025),
//          buttonTheme: ButtonThemeData(
//              buttonColor: Color(0xffAA00FF),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
//              textTheme: ButtonTextTheme.primary),
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
              color: Colors.green,
              textTheme: TextTheme(title: TextStyle(color: Colors.white))),
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            body1: TextStyle(color: Colors.white),
          ),
        ),
        home: Splash()
//      MyHomePage(
//        title: "Hifi",
//      ),

        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  File _image;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool showMessage = false;
  String message;
  TextEditingController textEditingController = new TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomSheet: showMessage
            ? Container(
                width: _width,
                color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            : Wrap(),
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                  width: _width,
                  height: _height,
                  child: InkWell(
                    onTap: () {
                      _save(context);
                    },
                    child: Image.asset(
                      "assets/hand.png",
                      fit: BoxFit.contain,
                    ),
                  )),
              Positioned(
                bottom: 10,
                width: _width,
                left: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white54,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(createRoute(SignInGoogle()));
                      },
                    ),
                    GestureDetector(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.insert_chart,
                            color: Colors.white54,
                          )),
                      onTap: () {
                        Navigator.of(context).push(createRoute(Stats()));
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                width: _width,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  child: Text(
                    "Tap on screen For HiFi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _hideMessage() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        showMessage = false;
        message = null;
      });
    });
  }

  _save(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get('email');
    if (email != null) {
      setState(() {
        showMessage = true;
        message = "logged your HiFi";
      });
      logHifi(message: "");
      _hideMessage();
//      return showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//                title: Text(
//                  "Enter Message",
//                  style: TextStyle(color: Colors.black),
//                ),
//                content: TextField(
//                  controller: textEditingController,
//                  decoration:
//                      InputDecoration(hintText: "Finished reading alchemist"),
//                ),
//                actions: <Widget>[
//                  RaisedButton(
//                    color: Colors.pinkAccent,
//                    onPressed: () {
//                      setState(() {
//                        showMessage = true;
//                        message = "logged your HiFi";
//                      });
//                      logHifi(message: textEditingController.text);
//                      _hideMessage();
//                      Navigator.pop(context);
//                    },
//                    child: Text("HiFI"),
//                  )
//                ],
//              ));
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("You are not login ! please login for HiFi"),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.pinkAccent,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(createRoute(SignInGoogle()));
                    },
                    child: Text("Click to Login"),
                  )
                ],
              ));
    }
  }
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void logHifi({String message}) async {
  var email = await getEmail();
  if (email != null) {
    try {
      var url = "http://dailybits.in/hifi.php?email=" +
          email.trim().toLowerCase() +
          "&hifi=log&message=" +
          message;
      Response response = await Dio().get(url);
    } catch (e) {
      print(e);
    }
  }
}
