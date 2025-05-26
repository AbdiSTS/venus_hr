import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/assets/assets.gen.dart';
import 'package:venus_hr_psti/core/extensions/extensions.dart';
import 'package:venus_hr_psti/page/home/attendance_log/attendance_log_viewmodel.dart';
import 'package:venus_hr_psti/page/home/home_view.dart';

import '../../../core/components/dotten_vertical.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/spaces.dart';
import '../../../core/components/styles.dart';
import '../../../core/constants/colors.dart';
import 'package:stacked/stacked.dart';

class AttendanceLogView extends StatefulWidget {
  const AttendanceLogView({super.key});

  @override
  State<AttendanceLogView> createState() => _AttendanceLogViewState();
}

class _AttendanceLogViewState extends State<AttendanceLogView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => AttendanceLogViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Stack(
            children: [
              Scaffold(
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
                                          setState(() {
                                            vm.dateFrom =
                                                '${pickedRange.start}';
                                            vm.dateTo = '${pickedRange.end}';
                                            vm.getListAttendanceLog();
                                          });
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
                                              color: const Color.fromARGB(
                                                  150, 0, 0, 0)),
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
                            dateTime: vm.selectedDate,
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
                                selectedBackgroundColor:
                                    const Color(0xff3AC3E2),
                                todayTextColor: Colors.white),
                            headerOptions: HeaderOptions(
                                weekDayStringType: WeekDayStringTypes.SHORT,
                                monthStringType: MonthStringTypes.FULL,
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                headerTextSize: 14,
                                headerTextColor: Colors.black),
                            onChangeDateTime: (dateTime) async {
                              setState(() {
                                vm.selectedDate = dateTime;
                                vm.dateFrom =
                                    '${DateFormat('yyy-MM-dd 00:00:00').format(DateTime.parse(dateTime.toString()))}';
                                vm.dateTo =
                                    '${DateFormat('yyy-MM-dd 00:00:00').format(DateTime.parse(dateTime.toString()))}';
                                vm.getListAttendanceLog();
                              });
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: vm.listAttendanceLog.length,
                                itemBuilder: (context, index) {
                                  final data = vm.listAttendanceLog[index];
                                  DateTime parsedDate = DateFormat('MM/dd/yyyy')
                                      .parse(data['TADate']);

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromARGB(75, 0, 0,
                                              0), // Warna garis border
                                          width: 0.5, // Ketebalan garis border
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${parsedDate.toFormattedDateDays()}",
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${data['CheckIn'] ?? '-'}",
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      "${data['CheckOut'] ?? '-'}",
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.black,
                                                  size: 13,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.4,
                                                  child: Text(
                                                    "${data['LocationIn']} (Check In)",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.black,
                                                  size: 13,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.4,
                                                  child: Text(
                                                    "${data['LocationOut'] ?? '-'} (Check Out)",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              vm.isBusy
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
        });
  }
}
