import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';

import '../../splash_screen/splash_screen.dart';

class AttendanceLogViewmodel extends FutureViewModel {
  BuildContext? ctx;
  List<dynamic> listAttendanceLog = [];
  String? dateFrom;
  String? dateTo;
  CalendarDateTime? selectedDate;
  AttendanceLogViewmodel({this.ctx});

  String subtractOneMonth(String inputDateStr) {
    DateTime selectedDate = DateTime.parse(inputDateStr);

    // Hitung tahun dan bulan baru
    int newYear =
        selectedDate.month == 1 ? selectedDate.year - 1 : selectedDate.year;
    int newMonth = selectedDate.month == 1 ? 12 : selectedDate.month - 1;

    // Hari terakhir di bulan sebelumnya
    int lastDayOfPrevMonth = DateTime(newYear, newMonth + 1, 0).day;

    // Sesuaikan tanggal jika perlu (misalnya dari 31 ke 30/28)
    int adjustedDay = selectedDate.day > lastDayOfPrevMonth
        ? lastDayOfPrevMonth
        : selectedDate.day;

    // Buat tanggal baru dan format ke String
    DateTime resultDate = DateTime(newYear, newMonth, adjustedDay);
    return DateFormat('yyyy-MM-dd').format(resultDate);
  }

  getListAttendanceLog() async {
    try {
      setBusy(true);
      final cekToken = await ApiServices().cekToken();
      DateTime now = DateTime.now();

      if (cekToken) {
        final response = await ApiServices().getListAttendanceLog(
            dateFrom ?? DateFormat('yyyy-MM-dd').format(now),
            '${dateTo ?? DateFormat('yyyy-MM-dd').format(now)}');

        if (response.success == true) {
          listAttendanceLog = List.from(response.listData!);
          print("listAttendanceLog : ${listAttendanceLog}");
          setBusy(false);
          notifyListeners();
        } else {
          setBusy(false);
          notifyListeners();
        }
      } else {
        ScaffoldMessenger.of(ctx!).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Session Expired , Please Login Again'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(ctx!).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashScreen()));
        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      print("erro : ${e}");
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {
    selectedDate = CalendarDateTime(
      year: DateTime.now().year,
      month: DateTime.now().month,
      day: DateTime.now().day,
    );
    await getListAttendanceLog();
  }
}
