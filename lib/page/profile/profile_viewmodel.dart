import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';

class ProfileViewmodel extends FutureViewModel {
  BuildContext? ctx;
  ProfileViewmodel({required this.ctx});

  String? employeeID;
  String? employeeName;
  String? employeeNIK;
  String? employeeEmail;
  String? employeePhone;
  String? employeeAddress;
  String? employeePosition;

  getUser() async {
    final response = await LocalServices().getAuthData();
    print('response detail : ${response?.dataDetail}');
    if (response?.success == true) {
      employeeID = response?.userData?[0].employeeID;
      employeeName = response?.dataDetail?[0]['EmployeeName'];
      employeeNIK = response?.dataDetail?[0]['NIK'];
      employeePhone = response?.dataDetail?[0]['PrivateMobile'];
      employeeAddress = response?.dataDetail?[0]['HomeAdr'];
      employeePosition = response?.dataDetail?[0]['Position'];
    }
  }

  @override
  Future futureToRun() async {
    await getUser();
  }
}
