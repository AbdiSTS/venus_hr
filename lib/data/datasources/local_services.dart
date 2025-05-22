import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalServices extends ChangeNotifier {
  Future<void> saveDataLogin(List<dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', jsonEncode(data));
  }

  Future<dynamic> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null) {
      return jsonDecode(data);
    } else {
      print("save data gagal getAuthData()");
      return null;
    }
  }
}
