import 'package:flutter/material.dart';
import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venus_hr_psti/page/home/home_viewmodel.dart';

class CardHolidayView extends StatefulWidget {
  HomeViewmodel? vm;
  CardHolidayView({
    Key? key,
    this.vm,
  });

  @override
  State<CardHolidayView> createState() => _CardHolidayViewState();
}

class _CardHolidayViewState extends State<CardHolidayView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.vm?.listDateHoliday?.listData?.length ?? 0,
        itemBuilder: (context, index) {
          final data = widget.vm?.listDateHoliday?.listData?[index];

          final description = data?['Description'] ?? '-';
          final holidayDateStr = data?['HolidayDate'];

          String formattedDate;
          try {
            formattedDate = holidayDateStr != null
                ? DateTime.parse(holidayDateStr).toFormattedDateDays()
                : '-';
          } catch (e) {
            formattedDate = '-';
          }

          return Stack(
            children: [
              Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        description,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        formattedDate,
                        style: GoogleFonts.lato(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -20,
                top: 10,
                child: Transform.rotate(
                  angle: -0.7,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 25),
                    color: Colors.red,
                    child: Text(
                      'Holiday',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
