import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/constants/variables.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';
import 'package:venus_hr_psti/data/models/response_result.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'api_base.dart';

class ApiServices extends ChangeNotifier {
  String? token;
  num? getTimeZone;

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

  Future<bool> hasInternetAccess() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      print("connectivityResult : ${connectivityResult}");
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        final result = await http
            .get(Uri.parse('https://api.sinergiteknologi.co.id/ApiVenusHR'))
            .timeout(
              const Duration(seconds: 5),
            );
        print("result.statusCode  : ${result.statusCode}");
        return result.statusCode == 200;
      } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
        if (connectivityResult.contains(ConnectivityResult.none)) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<ResponseResult> login(String? username, String? password) async {
    try {
      final cekConnection = await hasInternetAccess();

      if (!cekConnection) {
        return ResponseResult(
          message: 'No Internet Connection',
          success: false,
        );
      }

      final Map<String, dynamic> dataJson = {
        'key': 'VenusHR13Key',
        'userName': username,
        'password': password,
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
      };

      final url = Uri.parse(ApiBase().login());
      final response = await http.post(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));
      print("data body : ${jsonDecode(response.body)}");
      print("data status code : ${response.statusCode}");
      if (response.statusCode == 200) {
        return ResponseResult.fromJson(jsonDecode(response.body));
      } else {
        return ResponseResult.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error Login : ${e}");
      return ResponseResult(message: 'Failed Login');
    }
  }

  Future<bool> cekToken() async {
    try {
      final prefData = await LocalServices().getAuthData();
      token = prefData!.token;
      final url = Uri.parse(ApiBase().cekToken());
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
      print("Error Login : ${e}");
      return false;
    }
  }

  // ======================================= HOME ============================================================= //

  Future<ListDynamicModel> getLeaveSaldo() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'busCode': '${getUser?.userData?[0].busCode}',
      'employee': '${getUser?.userData?[0].employeeID}',
      'date': '${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
      'periode': '${DateFormat('yyyy/MM').format(DateTime.now())}',
      'year': '${DateFormat('yyyy').format(DateTime.now())}',
      'appName': '${ApiBase.appName}',
    };
    final url = Uri.parse(ApiBase().leaveSaldo());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response : ${jsonResponse}");

      return ListDynamicModel(
        success: true,
        listData: jsonDecode(response.body),
      );
    } else {
      return ListDynamicModel(
        success: false,
        listData: [],
      );
    }
  }

  Future<ListDynamicModel> getAssigmentLocation() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'employee': '${getUser?.userData?[0].employeeID}',
    };
    final url = Uri.parse(ApiBase().assigmentLocation());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response : ${jsonResponse}");

      return ListDynamicModel(
        success: true,
        listData: jsonDecode(response.body),
      );
    } else {
      return ListDynamicModel(
        success: false,
        listData: [],
      );
    }
  }
}
