import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/page/splash_screen/splash_screen.dart';

import '../../bottom_navigator_view.dart';

class LeaveViewmodel extends FutureViewModel {
  BuildContext? ctx;
  LeaveViewmodel({this.ctx});

  List<dynamic> listLeaveType = [];
  List<dynamic> listApprover = [];
  List<dynamic>? datalistDurasi = [
    {"type": "Full Day Leave"},
    {"type": "Half Day Leave"},
  ];

  String? selectedLeaveType;
  String? selectedApprover;
  String? selectedLeaveDuration;
  String? getDateFrom;
  String? selectedDateFrom;
  String? selectedDateTo;
  TextEditingController? reasonController = new TextEditingController();

  getLeaveType() async {
    final response = await ApiServices().getLeaveType();
    if (response.success == true) {
      listLeaveType = response.listData!;
      print("listLeaveType : ${listLeaveType}");
      notifyListeners();
    }
  }

  getAproverRequest() async {
    try {
      final response = await ApiServices().getApproverRequest();

      if (response.success == true && response.listData!.isNotEmpty) {
        listApprover = List.from(response.listData!);
      }
    } catch (e) {
      setBusy(false);
      notifyListeners();
    }
  }

  getRangeDate() async {
    try {
      final response = await ApiServices().getRangeDate();
      if (response.success == true) {
        if (response.listData!.isNotEmpty) {
          getDateFrom = DateFormat('yyyy,MM,dd')
              .format(DateTime.parse(data[0]['DateFrom']));

          notifyListeners();
        } else {
          setBusy(false);
          notifyListeners();
        }
      } else {
        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      setBusy(false);
      notifyListeners();
    }
  }

  runFunction() async {
    setBusy(true);
    await getLeaveType();
    await getAproverRequest();
    await getRangeDate();
    setBusy(false);
  }

  postLeave() async {
    try {
      setBusy(true);
      final responseToken = await ApiServices().cekToken();
      if (responseToken) {
        DateTime parseToDateTime =
            DateFormat('yyyy-MM-dd').parse(selectedDateTo!);
        DateTime parseFromDateTime =
            DateFormat('yyyy-MM-dd').parse(selectedDateFrom!);

        if (parseToDateTime.difference(parseFromDateTime).inDays == -1) {
          ScaffoldMessenger.of(ctx!).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Failed Date'),
              backgroundColor: Colors.red,
            ),
          );
          setBusy(false);
          notifyListeners();
        } else {
          final response = await ApiServices().postLeave(
            selectedLeaveType!,
            reasonController!.text,
            selectedDateFrom,
            selectedDateTo,
            selectedApprover,
            selectedLeaveDuration,
          );

          if (response.success == true) {
            ScaffoldMessenger.of(ctx!).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text('${response.message}'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(ctx!).pushReplacement(
                MaterialPageRoute(builder: (context) => BottomNavigatorView()));
            setBusy(false);
            notifyListeners();
          } else {
            ScaffoldMessenger.of(ctx!).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text('${response.message}'),
                backgroundColor: Colors.red,
              ),
            );
            setBusy(false);
            notifyListeners();
          }
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
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('${e}'),
          backgroundColor: Colors.red,
        ),
      );
      setBusy(false);
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd 00:00:00');
    return dateFormatter.format(date);
  }

  @override
  Future futureToRun() async {
    await runFunction();
  }
}
