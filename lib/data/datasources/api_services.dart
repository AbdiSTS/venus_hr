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

  Future<ListDynamicModel> getDateHoliday() async {
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
    };
    final url = Uri.parse(ApiBase().dateHoliday());
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

  Future<ListDynamicModel> getMonthlyPeriode() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      "busCode": "${getUser?.userData?[0].busCode}",
      "date1": "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
      "date2": "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
    };
    final url = Uri.parse(ApiBase().monthlyPeriode());
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

  Future<String> getNumberAbsen(String? periode) async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      "employee": "${getUser?.userData?[0].employeeID}",
      "periode": "${periode}",
    };
    final url = Uri.parse(ApiBase().getNumberAbsen());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response getNumberAbsen : ${jsonResponse}");

      return '${jsonResponse[0]['TADetailNumber']}';
    } else {
      return '';
    }
  }

  Future<String> getNumberPermission(String? periode) async {
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      "periode": "${periode}",
    };
    final url = Uri.parse(ApiBase().getAutoNumberPermission());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("json response getNumberPermission : ${jsonResponse}");

      return '${jsonResponse[0]['AutoNo']}';
    } else {
      return '';
    }
  }

  Future<ResponseResult> postAbsen(
      String? typeAbsen, String? latlang, String? address) async {
    try {
      final getMonthlyPeriodes = await getMonthlyPeriode();

      if (getMonthlyPeriodes.listData!.isEmpty) {
        return ResponseResult(success: false, message: 'Periode not yet set');
      } else {
        final autoNumber =
            await getNumberAbsen(getMonthlyPeriodes.listData![0]['Periode']);

        final getUser = await LocalServices().getAuthData();
        final Map<String, dynamic> dataJson = {
          'host': ApiBase.hostServer,
          'dbName': ApiBase.dbName,
          "BusCode": "${getUser?.userData?[0].busCode}",
          "TAPeriode": "${getMonthlyPeriodes.listData![0]['Periode']}",
          "TADetailNumber": "${autoNumber}",
          "EmployeeId": "${getUser?.userData?[0].employeeID}",
          "InOut": "${typeAbsen}",
          "LatLang": "${latlang}",
          "Location": "${address}",
        };
        final url = Uri.parse(ApiBase().postAbsen());
        final response = await http.post(url,
            headers: getHeaders(),
            body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

        if (response.statusCode == 201) {
          return ResponseResult(
              success: true,
              message: '${jsonDecode(response.body)['message']}');
        } else {
          return ResponseResult(
              success: false, listData: jsonDecode(response.body));
        }
      }
    } catch (e) {
      print("Error Absen : ${e}");
      return ResponseResult(success: false, listData: [
        {'Error Absen': '${e}'}
      ]);
    }
  }

// ====================================== PERMISSION  ============================================================ //

  Future<ListDynamicModel> getRangeDate() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'busCode': '${getUser?.userData?[0].busCode}',
      'date': '${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
    };
    final url = Uri.parse(ApiBase().getRangeDate());
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

  Future<ListDynamicModel> getApproverRequest() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'busCode': '${getUser?.userData?[0].busCode}',
      'employee': '${getUser?.userData?[0].employeeID}',
    };
    final url = Uri.parse(ApiBase().getApproverRequest());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));
    print("response approvar : ${jsonDecode(response.body)}");
    print("response approvar : ${response.statusCode}");
    if (response.statusCode == 201) {
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

  Future<ResponseResult> postPermission(
    String? permissionType,
    String? reason,
    String? fromDate,
    String? toDate,
    String? appRequest,
  ) async {
    try {
      final getUser = await LocalServices().getAuthData();
      final getMonthlyPeriodes = await getMonthlyPeriode();
      if (getMonthlyPeriodes.listData!.isNotEmpty) {
        final getAutoNumber = await getNumberPermission(
            getMonthlyPeriodes.listData![0]['Periode']);

        DateTime parseToDateTime = DateFormat('yyyy-MM-dd').parse(toDate!);
        DateTime parseFromDateTime = DateFormat('yyyy-MM-dd').parse(fromDate!);

        final Map<String, dynamic> dataJson = {
          'host': ApiBase.hostServer,
          'dbName': ApiBase.dbName,
          "BusCode": "${getUser?.userData?[0].busCode}",
          "AbsNumber":
              "ABS/${getUser?.userData?[0].busCode}/${getMonthlyPeriodes.listData![0]['Periode']}/${getAutoNumber}",
          "Periode": "${getMonthlyPeriodes.listData![0]['Periode']}",
          "EmployeeID": "${getUser?.userData?[0].employeeID}",
          "ApprovedBy": "",
          "AbsType": "${permissionType}",
          "AbsReason": "${reason}",
          "NoticedDate":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now())}",
          "FromDate": "${toDate}",
          "ToDate": "${fromDate}",
          "Description": "",
          "Duration":
              "${parseFromDateTime.difference(parseToDateTime).inDays + 1}",
          "AppDescription": "",
          "AppRequest": "${appRequest}",
          "AppStatus": "",
          "UserCreated": "${getUser?.userData?[0].userId}",
          "DateCreated":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now())}",
          "TimeCreated": "${DateFormat('kkmmss').format(DateTime.now())}",
          "UserModified": "",
          "TimeModified": "",
        };

        final url = Uri.parse(ApiBase().postPermission());
        final response = await http.post(url,
            headers: getHeaders(),
            body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));
        print("jsonDecode(response.body) : ${jsonDecode(response.body)}");
        if (response.statusCode == 201) {
          return ResponseResult(
            success: true,
            message: jsonDecode(response.body)['message'],
          );
        } else {
          return ResponseResult(
            success: false,
            message: jsonDecode(response.body)['message'],
          );
        }
      } else {
        return ResponseResult(success: false, message: 'Periode not yet set');
      }
    } catch (e) {
      print("Error : ${e}");
      return ResponseResult(success: false, message: 'Error : ${e}');
    }
  }
}
