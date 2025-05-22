import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/page/splash_screen/splash_screen.dart';

import '../../state_global/state_global.dart';

class HomeViewmodel extends FutureViewModel {
  BuildContext? ctx;
  HomeViewmodel({this.ctx});

  logout() async {
    setBusy(true);

    ctx!.read<GlobalLoadingState>().show();
    Future.delayed(
      Duration(seconds: 3),
      () async {
        final pref = await SharedPreferences.getInstance();
        pref.clear();
        Navigator.of(ctx!)
            .pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
        ctx!.read<GlobalLoadingState>().hide();
        setBusy(false);
        notifyListeners();
      },
    );
  }

  @override
  Future futureToRun() async {}
}
