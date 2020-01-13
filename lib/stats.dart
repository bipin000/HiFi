import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hifi/comman.dart';
import 'package:hifi/configure.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<Map<String, Object>> stats = [];

  @override
  void initState() {
    // TODO: implement initState
    statsHifi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My HiFi Stats"),
      ),
      body: stats.length > 0
          ? ListView(
              children: stats.map<Widget>((item) {
                return ListTile(
                  leading: Text(
                    item["date"],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent,
                    ),
                    child: Text(
                      item["count"].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            )
          : Center(
              child: Wrap(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 200,
                  child: Text(
                    "No stats",
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                )
              ],
            )),
    );
  }

  void statsHifi() async {
    var email = await getEmail();
    print(email);
    if (email != null) {
      try {
        var url = "http://dailybits.in/hifi.php?email=" +
            email.trim().toLowerCase() +
            "&hifi=stat";
        Response response = await Dio().get(url);
        Map<String, dynamic> parsed = json.decode(response.toString());
        List<Map<String, Object>> _stats = [];
        parsed.forEach((key, item) {
          var it = {"date": key, "count": item};
          _stats ..add(it);
        });

        setState(() {
          stats = _stats;
        });
      } catch (e) {
        print(e);
      }
    }
  }
}

class HifiStat {
  final String date;
  final int total;
  final String message;

  HifiStat({this.date, this.total, this.message});

  factory HifiStat.fromJson(Map<String, dynamic> json) {
    return HifiStat(
      date: json['date'] as String,
      total: json['total'] as int,
      message: json['message'] as String,
    );
  }
}
