import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/data/models/response_result.dart';
import 'package:venus_hr_psti/page/bottom_navigator_view.dart';

import '../../core/constants/colors.dart';

class LoginViewmodel extends FutureViewModel {
  BuildContext? ctx;
  LoginViewmodel({this.ctx});

  TextEditingController? usernameController = new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();

  ApiServices apiServices = new ApiServices();
  LocalServices localServices = new LocalServices();

  login() async {
    setBusy(true);
    final responseData = await apiServices.login(
        usernameController!.text, passwordController!.text);
    // print("responseData : ${}");
    final datas = ResponseResult.fromJson(responseData.toMap());
    print("data : ${datas.data}");
    if (responseData.data!.isNotEmpty) {
      await localServices.saveDataLogin(datas);
      Navigator.of(ctx!).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavigatorView(),
      ));
      setBusy(false);
      notifyListeners();
    } else {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text("Username or Password Wrong!"),
          backgroundColor: AppColors.red,
        ),
      );
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {
    setBusy(false);
  }
}
