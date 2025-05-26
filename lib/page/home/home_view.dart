import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:venus_hr_psti/core/components/card_holiday_view.dart';
import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';
import 'package:venus_hr_psti/page/home/attendance_log/attendance_log_view.dart';
import 'package:venus_hr_psti/page/home/home_viewmodel.dart';
import 'package:venus_hr_psti/page/home/leave/leave_view.dart';
import 'package:venus_hr_psti/page/home/overtime/overtime_view.dart';
import 'package:venus_hr_psti/page/home/permission/permision_view.dart';
import 'package:stacked/stacked.dart';
import '../../core/assets/assets.gen.dart';
import '../../core/components/button_bouncing.dart';
import '../../state_global/state_global.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => HomeViewmodel(ctx: context),
        builder: (context, vm, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.isBusy
                ? context.read<GlobalLoadingState>().show()
                : context.read<GlobalLoadingState>().hide();
          });
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Assets.images.bgHome.provider(),
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(87, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Image.asset(
                                                "assets/images/venusHR.png"),
                                          ),
                                          Container(
                                            height: 25,
                                            width: 105,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  elevation:
                                                      WidgetStatePropertyAll(
                                                          2)),
                                              onPressed: () {
                                                setState(() {
                                                  vm.logout();
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Logout",
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              155, 0, 0, 0),
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.logout,
                                                    size: 17,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(
                                            "${vm.dataUser?.userData?[0].userId ?? '-'}",
                                            maxLines: 2,
                                            minFontSize: 10,
                                            stepGranularity: 10,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 13,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${vm.namaJalan ?? '-'}",
                                                style: GoogleFonts.lato(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              vm.locationCheck();
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 12,
                                              child: Icon(
                                                color: Colors.black,
                                                Icons.refresh,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        DateTime.now().toFormattedTime(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${DateTime.now().toFormattedDateDays()}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      ),
                                      Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: vm
                                                    .listSaldoLeave?.listData!
                                                    .map((e) {
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        "${e['Saldo']}",
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${e['LeaveTypeName']} ${e['LeaveYear'] ?? ''}",
                                                        style: GoogleFonts.lato(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList() ??
                                                []),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Column(
                                      //       children: [
                                      //         Text(
                                      //           "${vm.listSaldoLeave?.listData?[0]['Saldo']}",
                                      //           style: GoogleFonts.lato(
                                      //             color: Colors.white,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           "Cuti Tahunan(2024)",
                                      //           style: GoogleFonts.lato(
                                      //             color: Colors.white,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     DottedVerticalLine(
                                      //       height: 50,
                                      //       dashHeight: 5,
                                      //       dashSpacing: 4,
                                      //       color: Colors.white,
                                      //     ),
                                      //     Column(
                                      //       children: [
                                      //         Text(
                                      //           "10",
                                      //           style: GoogleFonts.lato(
                                      //             color: Colors.white,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //         Text(
                                      //           "Cuti Tahunan (2025)",
                                      //           style: GoogleFonts.lato(
                                      //             color: Colors.white,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      )),
                ),
                Expanded(
                  flex: 2,
                  child: RefreshIndicator(
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      await vm.getAllFunction();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CardHolidayView(
                            vm: vm,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                BouncingButton(
                                  urlImage: "assets/images/check_in.png",
                                  judul: "Check In",
                                  onTap: () => vm.postAbsen('IN'),
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/check_out.png",
                                  judul: "Check Out",
                                  onTap: () => vm.postAbsen('OUT'),
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/permission.png",
                                  judul: "Permission",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PermisionView()));
                                  },
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/attendance.png",
                                  judul: "Attendance Log",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AttendanceLogView()));
                                  },
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/calender.png",
                                  judul: "Leave",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LeaveView()));
                                  },
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/overtime.png",
                                  judul: "Overtime",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OvertimeView()));
                                  },
                                ),
                                BouncingButton(
                                  urlImage: "assets/images/slip_gaji.png",
                                  judul: "Slip Gaji",
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OvertimeView()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
