import 'dart:convert';

class ListDynamicModel {
  bool? success;
  String? message;
  List<dynamic>? listData;

  ListDynamicModel({
    this.success,
    this.message,
    this.listData,
  });

  ListDynamicModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    listData = json['listData'];
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    data['message'] = this.message;
    data['listData'] = this.listData?.map((e) => e.toJson()).toList();

    return data;
  }
}
