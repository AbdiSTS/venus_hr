import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';
import 'package:venus_hr_psti/page/bottom_navigator_view.dart';
import 'package:venus_hr_psti/page/splash_screen/splash_screen.dart';

class PermisionViewmodel extends FutureViewModel {
  BuildContext? ctx;
  TextEditingController? reasonController = new TextEditingController();
  String? selectTypePermission;
  String? selectPermissionRequest;

  String? getDateFrom;
  DateTime? fromDate;

  String? selectedDateFrom;
  String? selectedDateTo;

  PermisionViewmodel({this.ctx});

  List<dynamic> listApprover = [];

  List<dynamic> datalistMM = [
    {
      "type": "Sick",
    },
    {
      "type": "Duty",
    },
    {
      "type": "Permit N Leave",
    },
    {
      "type": "Add Leave",
    },
    {
      "type": "Permit",
    },
    {
      "type": "Special Permit",
    },
  ];

  List<dynamic> datalistTypeSantan = [
    {
      "type": "Sick",
    },
    {
      "type": "Duty",
    },
    {
      "type": "Permit N Leave",
    },
    {
      "type": "Add Leave",
    },
    {
      "type": "Permit",
    },
    {
      "type": "Special Permit",
    },
  ];

  List<dynamic> datalistTypeNusantara = [
    {
      "TypeLangguage": "Sick",
      "type": "Izin Sakit (Dengan Surat Dokter)",
    },
    {
      "TypeLangguage": "Duty",
      "type": "Izin Ke Cabang/Pameran",
    },
    {
      "TypeLangguage": "Sick (Without Note)",
      "type": "Izin Sakit (Tanpa Surat Dokter)",
    },
    {
      "TypeLangguage": "ITD",
      "type": "Izin Terlambat",
    },
    {
      "TypeLangguage": "IPC",
      "type": "Izin Pulang Cepat",
    },
    {
      "TypeLangguage": "IK",
      "type": "Izin Keluar Kantor",
    },
    {
      "TypeLangguage": "Additional Leave",
      "type": "Izin Lain Lain",
    },
    {
      "TypeLangguage": "Out of Town Duty",
      "type": "PJD Dengan Absensi",
    },
    {
      "TypeLangguage": "Out of Town Duty 2",
      "type": "PJD Tanpa Absensi",
    },
    {
      "TypeLangguage": "Change Day",
      "type": "Ganti Hari",
    },
    {
      "TypeLangguage": "Picket Day",
      "type": "Hari Piket",
    },
  ];

  List<File> imageFiles = [];
  List<String> imageString = [];

  Future<void> pickImage() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      // print("image picked : ${pickedFile!.path}");
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        imageFiles.add(file);
        imageString.add(p.basename(file.path));
        notifyListeners();
      }
    } catch (e) {
      // print("error image : ${e}");
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

  getAproverRequest() async {
    try {
      final response = await ApiServices().getApproverRequest();
      print("listApprover : ${response.listData}");
      if (response.success == true && response.listData!.isNotEmpty) {
        listApprover = List.from(response.listData!);

        setBusy(false);
        notifyListeners();
      } else {
        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      setBusy(false);
      notifyListeners();
    }
  }

  postPermission() async {
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
          final response = await ApiServices().postPermission(
            selectTypePermission,
            reasonController!.text,
            selectedDateFrom,
            selectedDateTo,
            selectPermissionRequest,
            imageFiles,
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

  runFunction() async {
    setBusy(true);
    await getRangeDate();
    await getAproverRequest();
    setBusy(false);
  }

  @override
  Future futureToRun() async {
    await runFunction();
  }
}
