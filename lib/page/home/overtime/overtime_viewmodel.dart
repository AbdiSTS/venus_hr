import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';

import '../../bottom_navigator_view.dart';
import '../../splash_screen/splash_screen.dart';

class OvertimeViewmodel extends FutureViewModel {
  BuildContext? ctx;
  OvertimeViewmodel({this.ctx});
  List<dynamic> listOvertimeType = [];
  List<dynamic> listApprover = [];
  String? selectApproval;
  TextEditingController? overtimeDate = new TextEditingController();
  TextEditingController? reasonController = new TextEditingController();
  TextEditingController? timeFromController = new TextEditingController();
  TextEditingController? timeToController = new TextEditingController();
  String? selectedOvertimeTypeCode;
  String? selectedOvertimeTypeName;
  TimeOfDay? selectedTimeFrom;
  TimeOfDay? selectedTimeTo;

  Future<TimeOfDay?> showTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    RouteSettings? routeSettings,
    EntryModeChangeCallback? onEntryModeChanged,
    Offset? anchorPoint,
    Orientation? orientation,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context));

    final Widget dialog = TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: initialEntryMode,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
      orientation: orientation,
      onEntryModeChanged: onEntryModeChanged,
    );
    return showDialog<TimeOfDay>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
      },
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
    );
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd 00:00:00');
    return dateFormatter.format(date);
  }

// ====================================================================================================== //

  getOvertimeType() async {
    final response = await ApiServices().getOvertimeType();
    if (response.success == true) {
      listOvertimeType = response.listData!;
      print("listOvertimeType : ${listOvertimeType}");
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

  postOvertime() async {
    try {
      setBusy(true);
      final responseToken = await ApiServices().cekToken();

      if (responseToken) {
        final response = await ApiServices().postOvertime(
            selectedTimeFrom,
            selectedTimeTo,
            selectedOvertimeTypeCode,
            selectedOvertimeTypeName,
            overtimeDate?.text.toString(),
            timeFromController!.text,
            timeToController?.text,
            selectApproval,
            reasonController?.text);
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
      } else {
        await LocalServices().removeAuthData();
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

  runFunction() async {
    setBusy(true);
    await getOvertimeType();
    await getAproverRequest();
    setBusy(false);
  }

  @override
  Future futureToRun() async {
    await runFunction();
  }
}
