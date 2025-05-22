import 'dart:convert';

class UserModel {
  String? busCode;
  String? employeeID;
  String? userId;
  String? password;
  String? refBio1;
  String? refBio2;
  String? mobileLoginID;
  String? mobileDeviceID;
  String? userStatus;
  String? userCreated;
  String? dateCreated;
  String? timeCreated;
  String? userModified;
  String? dateModified;
  String? timeModified;

  UserModel({
    this.busCode,
    this.employeeID,
    this.userId,
    this.password,
    this.refBio1,
    this.refBio2,
    this.mobileLoginID,
    this.mobileDeviceID,
    this.userStatus,
    this.userCreated,
    this.dateCreated,
    this.timeCreated,
    this.userModified,
    this.dateModified,
    this.timeModified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    busCode = json["BusCode"];
    employeeID = json["EmployeeID"];
    userId = json["UserId"];
    password = json["Password"];
    refBio1 = json["RefBio1"];
    refBio2 = json["RefBio2"];
    mobileLoginID = json["MobileLoginID"];
    mobileDeviceID = json["MobileDeviceID"];
    userStatus = json["UserStatus"];
    userCreated = json["UserCreated"];
    dateCreated = json["DateCreated"];
    timeCreated = json["TimeCreated"];
    userModified = json["UserModified"];
    dateModified = json["DateModified"];
    timeModified = json["TimeModified"];
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "BusCode": busCode,
        "EmployeeID": employeeID,
        "UserId": userId,
        "Password": password,
        "RefBio1": refBio1,
        "RefBio2": refBio2,
        "MobileLoginID": mobileLoginID,
        "MobileDeviceID": mobileDeviceID,
        "UserStatus": userStatus,
        "UserCreated": userCreated,
        "DateCreated": dateCreated,
        "TimeCreated": timeCreated,
        "UserModified": userModified,
        "DateModified": dateModified,
        "TimeModified": timeModified,
      };

  UserModel copyWith({
    String? busCode,
    String? employeeID,
    String? userId,
    String? password,
    String? refBio1,
    String? refBio2,
    String? mobileLoginID,
    String? mobileDeviceID,
    String? userStatus,
    String? userCreated,
    String? dateCreated,
    String? timeCreated,
    String? userModified,
    String? dateModified,
    String? timeModified,
  }) {
    return UserModel(
      busCode: busCode ?? this.busCode,
      employeeID: employeeID ?? this.employeeID,
      userId: userId ?? this.userId,
      password: password ?? this.password,
      refBio1: refBio1 ?? this.refBio1,
      refBio2: refBio2 ?? this.refBio2,
      mobileLoginID: mobileLoginID ?? this.mobileLoginID,
      mobileDeviceID: mobileDeviceID ?? this.mobileDeviceID,
      userStatus: userStatus ?? this.userStatus,
      userCreated: userCreated ?? this.userCreated,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      userModified: userModified ?? this.userModified,
      dateModified: dateModified ?? this.dateModified,
      timeModified: timeModified ?? this.timeModified,
    );
  }
}
