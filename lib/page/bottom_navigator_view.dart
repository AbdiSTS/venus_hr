import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:venus_hr_psti/state_global/loading_overlay.dart';

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
                  icon: Assets.icons.nav.setting.svg(
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 1 ? AppColors.primary : AppColors.grey,
                      BlendMode.srcIn,
                    ),
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
