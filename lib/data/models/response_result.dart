import 'dart:convert';

class ResponseResult {
  bool? success;
  String? message;
  String? token;
  String? refreshTokens;
  List<dynamic>? data;

  ResponseResult({
    this.token,
    this.refreshTokens,
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  ResponseResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    refreshTokens = json['refreshTokens'];
    data = json['data'] ?? [];
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    data['refreshTokens'] = this.refreshTokens;
    data['data'] = this.data;
    return data;
  }
}
