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
      final getPref = await LocalServices().getAuthData();

      if (getPref == null) {
        Future.delayed(Duration(seconds: 3), () async {
          Navigator.of(ctx!)
              .push(MaterialPageRoute(builder: (context) => LoginView()));
        });
        setBusy(false);
      } else {
        final cekConnection = await ApiServices().hasInternetAccess();

        if (!cekConnection) {
          ScaffoldMessenger.of(ctx!).showSnackBar(
            SnackBar(
              content: Text("No Internet Connection"),
              backgroundColor: AppColors.red,
            ),
          );
        }
        final data = await apiServices.cekToken();
        if (data) {
          setBusy(false);
          Future.delayed(Duration(seconds: 3), () async {
            Navigator.of(ctx!).push(
                MaterialPageRoute(builder: (context) => BottomNavigatorView()));
          });

          notifyListeners();
        } else {
          Future.delayed(
            Duration(seconds: 3),
            () async {
              final pref = await SharedPreferences.getInstance();
              pref.clear();
              setBusy(false);
              Navigator.of(ctx!)
                  .push(MaterialPageRoute(builder: (context) => LoginView()));
            },
          );
          ScaffoldMessenger.of(ctx!).showSnackBar(
            SnackBar(
              content: Text("Your session has expired, please login again"),
              backgroundColor: AppColors.red,
            ),
          );

          notifyListeners();
        }
      }
    } catch (e) {
      print("Error : ${e}");
    }
  }

  @override
  Future futureToRun() async {
    await cekToken();
  }
}
