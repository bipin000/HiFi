import 'package:shared_preferences/shared_preferences.dart';

 getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('email');
}