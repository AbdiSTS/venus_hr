import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:venus_hr_psti/core/constants/variables.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/data/models/response_result.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'api_base.dart';

class ApiServices extends ChangeNotifier {
  String? token;

  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8('#Sinergi132465#Sinergi!132465!16');
    final iv = encrypt.IV.fromUtf8('ivSinergi#132465');

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base64;
  }

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Map<String, String> getHeadersToken() {
    return {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<ResponseResult> login(String? username, String? password) async {
    try {
      final Map<String, dynamic> dataJson = {
        'key': 'VenusHR13Key',
        'userName': username,
        'password': password,
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
      };

      final url = Uri.parse(ApiBase.login);
      final response = await http.post(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));
      print("data body : ${jsonDecode(response.body)}");
      if (response.statusCode == 201) {
        return ResponseResult.fromJson(jsonDecode(response.body));
      } else {
        return ResponseResult.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return ResponseResult(message: '');
    }
  }

  Future<bool> cekToken() async {
    try {
      final prefData = await LocalServices().getAuthData();
      token = prefData!.token;
      final url = Uri.parse(ApiBase.cekToken);
      final response = await http.get(
        url,
        headers: getHeadersToken(),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }



}
