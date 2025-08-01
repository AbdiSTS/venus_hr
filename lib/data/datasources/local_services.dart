import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:venus_hr_psti/data/models/response_result.dart';

class LocalServices extends ChangeNotifier {
  Future<void> saveDataLogin(ResponseResult data) async {
    final pref = await SharedPreferences.getInstance();
    print("data to json : ${data.toJson()}");
    await pref.setString('auth_data', data.toJson());
  }

  Future<ResponseResult?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    print("data pref : ${data}");
    if (data != null) {
      return ResponseResult.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
  }
}
