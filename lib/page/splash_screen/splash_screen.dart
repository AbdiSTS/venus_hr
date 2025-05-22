import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/page/splash_screen/splash_viewmodel.dart';
import '../../core/components/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SplashViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/venusHR.png"),
                SizedBox(
                  height: 60,
                ),
                loadingSpin,
              ],
            ),
          );
        });
  }
}
