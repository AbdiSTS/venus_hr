import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/page/profile/profile_viewmodel.dart';
import '../../core/assets/assets.gen.dart';
import '../../core/components/rounded_clipper.dart';
import '../../core/constants/colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ProfileViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: ClipPath(
                      clipper: BottomRoundedClipper(),
                      child: ClipPath(
                        clipper: BottomRoundedClipper(),
                        child: Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: Assets.images.bgHome.provider(),
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/venusHR.png",
                                      width: 80,
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 200,
                                child: AutoSizeText(
                                  "${vm.employeeName == '' ? '-' : vm.employeeName}",
                                  maxLines: 2,
                                  minFontSize: 15,
                                  stepGranularity: 15,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 200,
                                child: AutoSizeText(
                                  "${vm.employeeNIK == '' ? '-' : vm.employeeNIK}",
                                  maxLines: 2,
                                  minFontSize: 15,
                                  stepGranularity: 15,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  75, 0, 0, 0), // Warna garis border
                              width: 0.5, // Ketebalan garis border
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/address.png",
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: AutoSizeText(
                                    "${vm.employeeAddress == '' ? '-' : vm.employeeAddress}",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  75, 0, 0, 0), // Warna garis border
                              width: 0.5, // Ketebalan garis border
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/smartphone.png",
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: AutoSizeText(
                                    "${vm.employeePhone == '' ? '-' : vm.employeePhone}",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  75, 0, 0, 0), // Warna garis border
                              width: 0.5, // Ketebalan garis border
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/images/cardname.png",
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 180,
                                  child: AutoSizeText(
                                    "${vm.employeePosition == '' ? '-' : vm.employeePosition}",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
