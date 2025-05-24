import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/models/list_dynamic_model.dart';

class PermisionViewmodel extends FutureViewModel {
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

  @override
  Future futureToRun() {
    // TODO: implement futureToRun
    throw UnimplementedError();
  }
}
