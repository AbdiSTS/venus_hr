import 'dart:convert';
import 'package:venus_hr_psti/data/models/user_model.dart';

class ResponseResult {
  bool? success;
  String? message;
  String? token;
  String? refreshTokens;
  List<UserModel>? userData;
  List<dynamic>? listData;

  ResponseResult({
    this.token,
    this.refreshTokens,
    this.success = false,
    this.message = '',
    this.userData = const [],
    this.listData = const [],
  });

  ResponseResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    refreshTokens = json['refreshTokens'];
    listData = json['listData'];

    if (json['data'] != null && json['data'] is List) {
      userData = (json['data'] as List<dynamic>).map((e) {
        final Map<String, dynamic> userMap = e as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }).toList();
    } else {
      userData = [];
    }
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['refreshTokens'] = refreshTokens;
    data['listData'] = listData;
    data['data'] = userData?.map((e) => e.toMap()).toList();
    return data;
  }
}
