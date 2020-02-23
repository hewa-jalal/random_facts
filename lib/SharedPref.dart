import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  saveList(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  readList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }
}
