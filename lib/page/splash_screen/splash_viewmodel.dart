import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/page/bottom_navigator_view.dart';
import 'package:venus_hr_psti/page/login/login_view.dart';

import '../../core/constants/colors.dart';
import '../../data/datasources/api_services.dart';

class SplashViewmodel extends FutureViewModel {
  BuildContext? ctx;
  SplashViewmodel({this.ctx});
  ApiServices apiServices = new ApiServices();

  cekToken() async {
    try {
      setBusy(true);
    print("cek");
    final getPref = await LocalServices().getAuthData();
    print("getPref : ${getPref}");
    if (getPref == null) {
      Future.delayed(Duration(seconds: 3), () async {
        Navigator.of(ctx!)
            .push(MaterialPageRoute(builder: (context) => LoginView()));
      });
      setBusy(false);
    } else {
      final data = await apiServices.cekToken();
      print("data : $data");
      if (data) {
        Future.delayed(Duration(seconds: 3), () async {
          Navigator.of(ctx!).push(
              MaterialPageRoute(builder: (context) => BottomNavigatorView()));
        });
        setBusy(false);
        notifyListeners();
      } else {
        Future.delayed(Duration(seconds: 3), () async {
          Navigator.of(ctx!)
              .push(MaterialPageRoute(builder: (context) => LoginView()));
          ScaffoldMessenger.of(ctx!).showSnackBar(
            SnackBar(
              content: Text("Your Session is Expired , Please Login Again"),
              backgroundColor: AppColors.red,
            ),
          );
        });
        setBusy(false);
        notifyListeners();
      }
    }
    } catch (e) {
      print("error : ${e}");
    }
  }

  @override
  Future futureToRun() async {
    await cekToken();
  }
}
