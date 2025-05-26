import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/page/login/login_viewmodel.dart';
import '../../core/assets/assets.gen.dart';
import '../../core/components/buttons.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/spaces.dart';
import '../../core/components/styles.dart';
import '../../core/constants/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isShowPassword = false;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LoginViewmodel(ctx: context),
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SpaceHeight(50),
                          Image.asset(
                            "assets/images/logo_login.png",
                            height: 200,
                          ),
                          const SpaceHeight(107),
                          CustomTextField(
                            controller: vm.usernameController!,
                            label: 'User ID',
                            showLabel: false,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                Assets.icons.email.path,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          const SpaceHeight(20),
                          CustomTextField(
                            controller: vm.passwordController!,
                            label: 'Password',
                            showLabel: false,
                            obscureText: !isShowPassword,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                Assets.icons.password.path,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShowPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                            ),
                          ),
                          const SpaceHeight(104),
                          Button.filled(
                            onPressed: () {
                              // vm.cekToken();
                              vm.login();
                            },
                            label: 'Login',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                vm.isBusy
                    ? const Stack(
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
                    : const Stack()
              ],
            ),
          );
        });
  }
}
