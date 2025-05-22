import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';
import 'package:venus_hr_psti/page/home/attendance_log/attendance_log_view.dart';
import 'package:venus_hr_psti/page/home/leave/leave_view.dart';
import 'package:venus_hr_psti/page/home/overtime/overtime_view.dart';
import 'package:venus_hr_psti/page/home/permission/permision_view.dart';

import '../../core/assets/assets.gen.dart';
import '../../core/components/button_bouncing.dart';
import '../../core/components/dotten_vertical.dart';
import '../../core/constants/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
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
                            color: const Color.fromARGB(87, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10)),
                        height: 270,
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
                                    SizedBox(
                                      width: 150,
                                      child: AutoSizeText(
                                        "Muhammad Abdillah Dzikri",
                                        maxLines: 2,
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/images/venusHR.png"),
                                    )
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
                                      "Jl. Benyamin Suaeb No.13, RT.13/RW.6, Kebon Kosong",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  DateTime.now().toFormattedTime(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${DateTime.now().toFormattedDate()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "10",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Cuti Tahunan(2024)",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    DottedVerticalLine(
                                      height: 50,
                                      dashHeight: 5,
                                      dashSpacing: 4,
                                      color: Colors.white,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "10",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Cuti Tahunan (2025)",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                )),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/check_in.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Check In",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/check_out.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Check Out",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PermisionView())),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/permission.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Permission",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendanceLogView())),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/attendance.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Attendance Log",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LeaveView())),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/calender.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Leave",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OvertimeView())),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/overtime.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Overtime",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/slip_gaji.png",
                              width: 70,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Slip Gaji",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
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
  }
}
