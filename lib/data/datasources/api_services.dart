import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/constants/variables.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';
import 'package:venus_hr_psti/data/models/response_result.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'api_base.dart';
import 'package:path/path.dart' as path;

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

  Future<String> getAutoNumberLeave(String? periode) async {
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      "periode": "${periode}",
    };
    final url = Uri.parse(ApiBase().getAutoNumberLeave());
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
    List<File> imageFiles,
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
          "FromDate": "${fromDate}",
          "ToDate": "${toDate}",
          "Description": "",
          "Duration":
              "${parseToDateTime.difference(parseFromDateTime).inDays + 1}",
          "AppDescription": "",
          "AppRequest": "${appRequest}",
          "AppStatus": "",
          "AppDate": "",
          "UserCreated": "${getUser?.userData?[0].userId}",
          "DateCreated":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now())}",
          "TimeCreated": "${DateFormat('kkmmss').format(DateTime.now())}",
          "UserModified": "",
          "TimeModified": "",
          "DateModified": "",
        };

        final url = Uri.parse(ApiBase().postPermission());
        final response = await http.post(url,
            headers: getHeaders(),
            body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

        if (response.statusCode == 201) {
          print("imageFiles  ${imageFiles}");
          await postAttendance(imageFiles, getAutoNumber,
              getMonthlyPeriodes.listData![0]['Periode']);
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

  Future<ResponseResult> postAttendance(
      List<File> imageFiles, String? getAutoNumber, String? periode) async {
    try {
      final getUser = await LocalServices().getAuthData();
      final url = Uri.parse('${ApiBase.baseUrl}/postImgAttendance');

      int jumlah = 0;
      for (var i in imageFiles) {
        final extension = path.extension(i.path);
        var request = http.MultipartRequest('POST', url);
        request.fields['host'] = "${ApiBase.hostServer}";
        request.fields['dbName'] = "${ApiBase.dbName}";
        request.fields['TranIdx'] = "05003";
        request.fields['TranNumber'] =
            "ABS/${getUser?.userData?[0].busCode}/${periode}/${getAutoNumber}";
        request.fields['ImageId'] = "${jumlah}";
        request.fields['FileName'] =
            "ABS${getUser?.userData?[0].busCode}${periode}${getAutoNumber}${jumlah}${extension}";

        var file = await http.MultipartFile.fromBytes(
          'Attachment',
          File(i.path).readAsBytesSync(),
          filename: i.path,
          contentType: MediaType('image', 'jpeg'),
        );

        request.files.add(file);

        print("notif request.fields : ${request.fields} }");
        print("notif request.files : ${request.files}");

        var response = await request.send();

        print("response attendance : ${response.stream.bytesToString()}");

        jumlah++;
        notifyListeners();
      }
      notifyListeners();
      return ResponseResult(success: false, message: 'Failed Upload Image');
    } catch (e) {
      print("Error image : ${e}");
      return ResponseResult(success: false, message: 'Failed Upload Image');
    }
  }

// ================================== ATTENDANCE LOG ============================================================ //

  Future<ListDynamicModel> getListAttendanceLog(
      String? dateFrom, String? dateTo) async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'employee': '${getUser?.userData?[0].employeeID}',
      'dateFrom':
          '${DateFormat('yyyy-MM-dd').format(DateTime.parse(dateFrom!))}',
      'dateTo': '${DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTo!))}',
    };
    final url = Uri.parse(ApiBase().getListAttendanceLog());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

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

// ================================== LEAVE ===================================================================== //

  Future<ListDynamicModel> getLeaveType() async {
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
    };

    final url = Uri.parse(ApiBase().getLeaveType());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

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

  Future<ResponseResult> postLeave(
    String leaveType,
    String? reason,
    String? fromDate,
    String? toDate,
    String? appRequest,
    String? leaveDuration,
  ) async {
    try {
      final getUser = await LocalServices().getAuthData();
      final getMonthlyPeriodes = await getMonthlyPeriode();

      if (getMonthlyPeriodes.listData!.isNotEmpty) {
        final getAutoNumber = await getAutoNumberLeave(
            getMonthlyPeriodes.listData![0]['Periode']);
        DateTime dateTime = DateTime.now();
        DateTime parseToDateTime = DateFormat('yyyy-MM-dd').parse(toDate!);
        DateTime parseFromDateTime = DateFormat('yyyy-MM-dd').parse(fromDate!);
        String years = DateFormat('yyyy').format(dateTime);

        double durasiHari;

        if (leaveDuration!.contains('Half Day Leave')) {
          durasiHari = (0.5 *
                  (parseFromDateTime.difference(parseToDateTime).inDays + 1)
                      .toInt())
              .toDouble();
        } else {
          durasiHari = parseFromDateTime.difference(parseToDateTime).inDays + 1;
        }

        final Map<String, dynamic> dataJson = {
          'host': ApiBase.hostServer,
          'dbName': ApiBase.dbName,
          "BusCode": "${getUser?.userData?[0].busCode}",
          "LVNumber":
              "LV/${getUser?.userData?[0].busCode}/${getMonthlyPeriodes.listData![0]['Periode']}/${getAutoNumber}",
          "Periode": "${getMonthlyPeriodes.listData![0]['Periode']}",
          "EmployeeID": "${getUser?.userData?[0].employeeID}",
          "ApprovedBy": "",
          "LeaveTypeCode": "${leaveType}",
          "LVReason": "${reason}",
          "NoticedDate":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now())}",
          "FromDate": "${fromDate}",
          "ToDate": "${toDate}",
          "Description": "",
          "LVDuration": "${leaveDuration}",
          "LVDay": durasiHari,
          "LeaveYear": "${years}",
          "Payment": "False",
          "AppDescription": "",
          "AppRequest": "${appRequest}",
          "AppStatus": "",
          "AppDate": "",
          "UserCreated": "${getUser?.userData?[0].userId}",
          "DateCreated":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now())}",
          "TimeCreated": "${DateFormat('kkmmss').format(DateTime.now())}",
          "UserModified": "",
          "TimeModified": "",
          "DateModified": "",
        };

        print("data json : ${dataJson}");
        final url = Uri.parse(ApiBase().postDataLeave());
        final response = await http.post(url,
            headers: getHeaders(),
            body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

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

// ================================ REQUEST =================================================================== //
  Future<ListDynamicModel> getListMyRequest() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'employee': '${getUser?.userData?[0].employeeID}',
    };

    final url = Uri.parse(ApiBase().getListMyRequest());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

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

  Future<ListDynamicModel> getListApproveRequest() async {
    final getUser = await LocalServices().getAuthData();
    final Map<String, dynamic> dataJson = {
      'host': ApiBase.hostServer,
      'dbName': ApiBase.dbName,
      'employee': '${getUser?.userData?[0].employeeID}',
    };

    final url = Uri.parse(ApiBase().getListApproveRequest());
    final response = await http.post(url,
        headers: getHeaders(),
        body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

    if (response.statusCode == 201) {
      notifyListeners();
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

  Future<ListDynamicModel> updateRequest(
      String employeeId, String tranNo, String tranName, String status) async {
    try {
      final getUser = await LocalServices().getAuthData();
      DateTime dateTime = DateTime.now();

      String? endPoint;
      String? tranNumber;

      if (tranName == "Permission") {
        endPoint = "updatePermission";
        tranNumber = "AbsNumber";
      } else if (tranName == "Leave") {
        endPoint = "updateLeave";
        tranNumber = "LVNumber";
      } else if (tranName == "Loan") {
        endPoint = "updateLoan";
        tranNumber = "LOANNumber";
      } else if (tranName == "Overtime") {
        endPoint = "updateOvertime";
        tranNumber = "OTNumber";
      }

      final Map<String, dynamic> data = {
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
        "${tranNumber}": "${tranNo}",
        "EmployeeID": "${employeeId}",
        "ApprovedBy": "${getUser?.userData?[0].employeeID}",
        if (status == "Rejected") "AppStatus": "Rejected",
        "AppDate": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
        "UserModified": "${getUser?.userData?[0].userId}",
        "DateModified": "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
        "TimeModified": "${DateFormat('kkmmss').format(dateTime)}",
      };

      final url = Uri.parse(ApiBase().updateRequest(endPoint));
      final response = await http.patch(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(data))}));

      print("url : ${url}");
      print("response : ${response.statusCode}");
      print("response : ${response.body}");
      print("data : ${data}");
      if (response.statusCode == 201) {
        return ListDynamicModel(
          success: true,
          message: jsonDecode(response.body)['message'],
        );
      } else {
        return ListDynamicModel(
          success: false,
          message: jsonDecode(response.body)['message'],
        );
      }
    } catch (e) {
      print("error : ${e}");
      return ListDynamicModel(
        success: false,
        message: '${e}',
      );
    }
  }

  Future<ListDynamicModel> deleteRequest(
      String employeeId, String tranNo, String tranName) async {
    try {
      final getUser = await LocalServices().getAuthData();
      DateTime dateTime = DateTime.now();

      String? nameTable;
      String? tranNumber;

      if (tranName == "Permission") {
        nameTable = "HR_T_Absence";
        tranNumber = "AbsNumber";
      } else if (tranName == "Leave") {
        nameTable = "HR_T_Leave";
        tranNumber = "LVNumber";
      } else if (tranName == "Loan") {
        nameTable = "HR_T_Loan";
        tranNumber = "LOANNumber";
      } else if (tranName == "Overtime") {
        nameTable = "HR_T_Overtime";
        tranNumber = "OTNumber";
      }

      final Map<String, dynamic> data = {
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
        "typeNumber": "${tranNumber}",
        "numberRequest": "${tranNo}",
        "nameTable": "${nameTable}",
      };

      final url = Uri.parse(ApiBase().deleteRequest());
      final response = await http.post(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(data))}));

      if (response.statusCode == 201) {
        return ListDynamicModel(
          success: true,
          message: jsonDecode(response.body)['message'],
        );
      } else {
        return ListDynamicModel(
          success: false,
          message: jsonDecode(response.body)['message'],
        );
      }
    } catch (e) {
      print("error : ${e}");
      return ListDynamicModel(
        success: false,
        message: '${e}',
      );
    }
  }

// ================================== HISTORY =================================================================== //

  Future<ListDynamicModel> getListHistoryRequest(
      String dateFrom, String dateTo, String type) async {
    try {
      final getUser = await LocalServices().getAuthData();
      final Map<String, dynamic> dataJson = {
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
        'employee': '${getUser?.userData?[0].employeeID}',
        'date1': '${dateFrom}',
        'date2': '${dateTo}',
        'status': '${type}',
      };

      final url = Uri.parse(ApiBase().getListHRReqHistory());
      final response = await http.post(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

      if (response.statusCode == 200) {
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
    } catch (e) {
      print("error : ${e}");
      return ListDynamicModel(
        success: false,
        message: '${e}',
      );
    }
  }

// ================================== OVERTIME =================================================================== //

  Future<ListDynamicModel> getOvertimeType() async {
    try {
      final Map<String, dynamic> dataJson = {
        'host': ApiBase.hostServer,
        'dbName': ApiBase.dbName,
      };
      final url = Uri.parse(ApiBase().getOvertimeType());
      final response = await http.post(url,
          headers: getHeaders(),
          body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

      if (response.statusCode == 200) {
        return ListDynamicModel(
          success: true,
          listData: jsonDecode(response.body),
        );
      } else {
        return ListDynamicModel(
          success: false,
          listData: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return ListDynamicModel(
        success: false,
        listData: [],
      );
    }
  }

  Future<ResponseResult> postOvertime(
    TimeOfDay? selectedTime,
    TimeOfDay? selectedTime2,
    String? overtimeTypeCode,
    String? overtimeTypeName,
    String? overtimeDate,
    String? timeFrom,
    String? timeTo,
    String? appRequest,
    String? reason,
  ) async {
    try {
      final getUser = await LocalServices().getAuthData();
      final getMonthlyPeriodes = await getMonthlyPeriode();
      String? otindeks;
      DateTime dateTime = DateTime.now();

      final minutes1 = selectedTime!.hour * 60 + selectedTime.minute;
      final minutes2 = selectedTime2!.hour * 60 + selectedTime2.minute;

      final diffreneceInMinutes = (minutes2 - minutes1).abs();
      final hours = diffreneceInMinutes ~/ 60;
      final minutes = diffreneceInMinutes % 60;

      print("diffreneceInMinutes : ${diffreneceInMinutes}");
      print("overtime date  : ${overtimeDate}");
      String? otStartConvert =
          "${DateFormat('yyyy-MM-dd').format(DateTime.parse(overtimeDate!))} ${timeFrom}";
      String? otFinishConvert =
          "${DateFormat('yyyy-MM-dd').format(DateTime.parse(overtimeDate))} ${timeTo}";

      if (overtimeTypeName == 'LEMBUR_HARIKERJA') {
        if (diffreneceInMinutes >= 60) {
          double indexForFirstHour = 1.5;
          int remainingMinutes = diffreneceInMinutes - 60;
          int intervals = remainingMinutes ~/ 30;
          double index = indexForFirstHour;
          otindeks = "${indexForFirstHour}";
          print("otindeks : ${otindeks}");
          for (int i = 0; i < intervals; i++) {
            index += 1.0;
            otindeks = "${index}";
            // printDataEvery30Minutes(index);
          }
        }
      } else {
        if (diffreneceInMinutes >= 60) {
          double indexForFirstHour = 2.0;

          int remainingMinutes = diffreneceInMinutes - 60;
          int intervals = remainingMinutes ~/ 30;
          double index = indexForFirstHour;
          otindeks = "${indexForFirstHour}";
          for (int i = 0; i < intervals; i++) {
            index += 1.0;
            otindeks = "${index}";
            // printDataEvery30Minutes(index);
          }
        }
      }

      if (getMonthlyPeriodes.listData!.isNotEmpty) {
        final Map<String, dynamic> dataJson = {
          'host': ApiBase.hostServer,
          'dbName': ApiBase.dbName,
          "BusCode": "${getUser?.userData?[0].busCode}",
          "OTNumber":
              "${getUser?.userData?[0].employeeID}${getMonthlyPeriodes.listData![0]['Periode']}${DateFormat('dd').format(DateTime.parse(overtimeDate!))}",
          "OTPeriode": "${getMonthlyPeriodes.listData![0]['Periode']}",
          "OTDate": "${overtimeDate}",
          "EmployeeID": "${getUser?.userData?[0].employeeID}",
          "OTTypeCode": "${overtimeTypeCode}",
          "OTStart":
              "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(otStartConvert))}",
          "OTFinish":
              "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(otFinishConvert))}",
          "OTBreak": "",
          "OTTimeDuration": "${diffreneceInMinutes}",
          "OTIndeks": "${otindeks}",
          "OTMeals": "0",
          "OTTransport": "0",
          "OTOther": "0",
          "Description": "${reason}",
          "ActualOTIndeks": "0",
          "ActualOTMeals": "0",
          "ActualOTTransport": "0",
          "DefaultOvertime": false,
          "AppRequest": "${appRequest}",
          "ApprovedBy": "",
          "AppStatus": "",
          "AppDescription": "",
          "OTHourDuration": "${hours}.${minutes}",
          "UserCreated": "${getUser?.userData?[0].userId}",
          "DateCreated":
              "${DateFormat('yyyy-MM-dd 00:00:00').format(dateTime)}",
          "TimeCreated": "${DateFormat('kkmmss').format(dateTime)}",
          "UserModified": "",
          "DateModified": "",
          "TimeModified": ""
        };

        print("dataJson overtime : ${dataJson}");
        final url = Uri.parse(ApiBase().postOvertime());
        final response = await http.post(url,
            headers: getHeaders(),
            body: jsonEncode({'data': encryptData(jsonEncode(dataJson))}));

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
