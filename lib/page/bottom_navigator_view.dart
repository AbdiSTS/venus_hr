import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/page/request/request_viewmodel.dart';
import 'package:venus_hr_psti/state_global/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:venus_hr_psti/data/datasources/api_base.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../core/assets/assets.gen.dart';
import '../core/components/styles.dart';
import '../core/constants/colors.dart';
import '../state_global/state_global.dart';
import 'history/history_view.dart';
import 'home/home_view.dart';
import 'profile/profile_view.dart';
import 'request/request_view.dart';

class BottomNavigatorView extends StatefulWidget {
  const BottomNavigatorView({super.key});

  @override
  State<BottomNavigatorView> createState() => _BottomNavigatorViewState();
}

class _BottomNavigatorViewState extends State<BottomNavigatorView> {
  int _selectedIndex = 0;

  final _widgets = [
    const HomeView(),
    const RequestView(),
    const HistoryView(),
    const ProfileView(),
  ];



  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<GlobalLoadingState>().isLoading;
    final lengthApproveRequest = context.watch<GlobalLoadingState>().getlengthApproveRequestVariabel;
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgets,
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              useLegacyColorScheme: false,
              currentIndex: _selectedIndex,
              onTap: (value) => setState(() => _selectedIndex = value),
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(color: AppColors.primary),
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Assets.icons.nav.home.svg(
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 0 ? AppColors.primary : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      // Icon utama
                      Assets.icons.nav.setting.svg(
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 1
                              ? AppColors.primary
                              : AppColors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      // Badge notifikasi
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${lengthApproveRequest}', // Ganti dengan jumlah notifikasi yang diinginkan
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: 'Request',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.nav.history.svg(
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 2 ? AppColors.primary : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.nav.profile.svg(
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 3 ? AppColors.primary : AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Stack(
                children: [
                  ModalBarrier(
                    dismissible: false,
                    color: const Color.fromARGB(118, 0, 0, 0),
                  ),
                  Center(
                    child: loadingSpinWhiteSizeBig,
                  ),
                ],
              )
            : Stack()
      ],
    );
  }
}
