import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venus_hr_psti/core/assets/assets.gen.dart';
import 'package:venus_hr_psti/core/extensions/extensions.dart';
import 'package:venus_hr_psti/page/home/home_view.dart';

import '../../../core/components/dotten_vertical.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class AttendanceLogView extends StatefulWidget {
  const AttendanceLogView({super.key});

  @override
  State<AttendanceLogView> createState() => _AttendanceLogViewState();
}

class _AttendanceLogViewState extends State<AttendanceLogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: BottomRoundedClipper(),
                    child: Container(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          "Attendance Log",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16, // posisi dari kiri
                    top: 5,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/back.svg",
                          color: Colors.white,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((pickedRange) {
                              if (pickedRange != null) {
                                print('Start: ${pickedRange.start}');
                                print('End: ${pickedRange.end}');
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 17,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Select Range Date",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(150, 0, 0, 0)),
                              )
                            ],
                          )),
                      Container(),
                    ],
                  ),
                ),
                TimelineCalendar(
                  calendarType: CalendarType.GREGORIAN,
                  calendarLanguage: "en",
                  calendarOptions: CalendarOptions(
                      viewType: ViewType.DAILY,
                      toggleViewType: true,
                      headerMonthElevation: 10,
                      headerMonthShadowColor: Colors.transparent,
                      headerMonthBackColor: Colors.transparent,
                      weekStartDate: DateTime.now(),
                      weekEndDate: DateTime.now()),
                  dayOptions: DayOptions(
                      compactMode: true,
                      dayFontSize: 14.0,
                      disableFadeEffect: true,
                      weekDaySelectedColor: const Color(0xff3AC3E2),
                      differentStyleForToday: true,
                      todayBackgroundColor: Colors.black,
                      selectedBackgroundColor: const Color(0xff3AC3E2),
                      todayTextColor: Colors.white),
                  headerOptions: HeaderOptions(
                      weekDayStringType: WeekDayStringTypes.SHORT,
                      monthStringType: MonthStringTypes.FULL,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      headerTextSize: 14,
                      headerTextColor: Colors.black),
                  onChangeDateTime: (dateTime) {},
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${DateTime.now().toFormattedDateDays()}",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "07:50",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "Check In",
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              DottedVerticalLine(
                                height: 50,
                                dashHeight: 5,
                                dashSpacing: 4,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "17:50",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "Check Out",
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.black,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Jl. Benyamin Suaeb No.13, RT.13/RW.6, Kebon Kosong",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
