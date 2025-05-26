import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';

class PermisionViewmodel extends FutureViewModel {
  TextEditingController? reasonController = new TextEditingController();
  String? selectTypePermission;
  String? selectPermissionRequest;

  String? getDateFrom;
  String? getDateTo;
  DateTime? fromDate;

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

  DateTime? parseDateFromString(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      final parts = value.split(',');
      if (parts.length < 3) return null;

      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

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
              .format(DateTime.parse(response.listData?[0]['DateFrom']));
          getDateTo = DateFormat('yyyy,MM,dd')
              .format(DateTime.parse(response.listData?[0]['DateTo']));

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
