import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show json;

import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>['email'],
);

class SignInGoogle extends StatefulWidget {
  @override
  State createState() => SignInGoogleState();
}

class SignInGoogleState extends State<SignInGoogle> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      _saveUser(
          email: account.email,
          name: account.displayName,
          profilepic: account.photoUrl);
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() {
    _googleSignIn.disconnect();
    _deleteUser();
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(
              _currentUser.displayName ?? '',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _currentUser.email ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Text("Signed in successfully."),
//          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('GOOGLE SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _currentUser != null
              ? const Text('Sign Out')
              : const Text('Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

//_saveaccount(account) async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  await prefs.setString('account',account);
//
//}

_saveUser({String email, String name, String profilepic}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('profilepic', profilepic);
  await prefs.setString('name', name);
}

_getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.get('email');
  await prefs.get('profilepic');
  await prefs.get('name');
}

_deleteUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('profilepic');
  await prefs.remove('name');
}
