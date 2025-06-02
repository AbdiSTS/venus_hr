import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/data/datasources/local_services.dart';
import 'package:venus_hr_psti/data/models/response_result.dart';
import 'package:venus_hr_psti/page/splash_screen/splash_screen.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import '../../core/constants/colors.dart';
import '../../data/models/list_dynamic_model.dart';
import '../../state_global/state_global.dart';

class HomeViewmodel extends FutureViewModel {
  BuildContext? ctx;
  HomeViewmodel({this.ctx});
  ResponseResult? dataUser;

  bool foundInRange = false;
  LatLng? currentLocation;
  String? address;
  String? namaJalan;
  String? latlang;

  ListDynamicModel? listSaldoLeave;
  ListDynamicModel? listDateHoliday = new ListDynamicModel();
  ListDynamicModel? listAssigmentLocation;

  logout() async {
    setBusy(true);
    ctx!.read<GlobalLoadingState>().show();
    Future.delayed(
      Duration(seconds: 3),
      () async {
        final pref = await SharedPreferences.getInstance();
        pref.clear();
        Navigator.of(ctx!).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashScreen()));
        ctx!.read<GlobalLoadingState>().hide();
        setBusy(false);
        notifyListeners();
      },
    );
  }

  getDataUser() async {
    try {
      dataUser = await LocalServices().getAuthData();
      notifyListeners();
    } catch (e) {
      print("Error get data user : ${e}");
    }
  }

  getLeaveSaldo() async {
    try {
      final dataLeaveSaldo = await ApiServices().getLeaveSaldo();
      print("dataLeaveSaldo : ${dataLeaveSaldo.listData}");
      if (dataLeaveSaldo.success == true) {
        listSaldoLeave = dataLeaveSaldo;
        notifyListeners();
      } else {
        setBusy(false);
      }
    } catch (e) {
      print("Error Saldo Leave : ${e}");
      setBusy(false);
    }
  }

  getDateHoliday() async {
    try {
      final dataDateHoliday = await ApiServices().getDateHoliday();

      if (dataDateHoliday.success == true) {
        listDateHoliday = dataDateHoliday;
        notifyListeners();
      } else {
        setBusy(false);
      }
    } catch (e) {
      print("Error Saldo Leave : ${e}");
      setBusy(false);
    }
  }

  setLocationName() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLocation = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude, currentLocation!.longitude);
    latlang = '${currentLocation!.latitude},${currentLocation!.longitude}';
    Placemark placemark = placemarks[0];
    address =
        "${placemark.street}, ${placemark.name}, ${placemark.subLocality}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
    namaJalan = "${placemark.street}";
    notifyListeners();
  }

  postAbsen(String? typeAbsen) async {
    try {
      setBusy(true);
      final response = await assigmentLocation();

      if (response) {
        await setLocationName();
        final response = await ApiServices().postAbsen(
          typeAbsen,
          latlang,
          namaJalan,
        );
        _showSuccess('${response.message}');
        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      _showError('Error : ${e}');
      setBusy(false);
      notifyListeners();
    }
  }

// ======================FUNCTION PENGECEKAN============================================= //

  Future<bool> cekRangeLocation(List<dynamic> data) async {
    int index = 0; // Inisialisasi indeks untuk while loop
    Position userPosition = await Geolocator.getCurrentPosition();
    while (index < data.length && !foundInRange) {
      double allowedRadius = data[index]['Radius'] ?? 100;
      String? latlong = data[index]['Coordinates'];

      double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        double.parse(latlong?.split(',')[0] ?? '0.0'),
        double.parse(latlong?.split(',')[1] ?? '0.0'),
      );

      if (distance <= allowedRadius) {
        foundInRange = true;
        notifyListeners();
      }

      index++;
    }
    notifyListeners();
    return foundInRange; // Kembalikan true jika ditemukan jarak <= 0.1
  }

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true; // Lokasi diberikan izin
  }

  Future<bool> isLocationValid() async {
    try {
      // Ambil lokasi
      Position position = await Geolocator.getCurrentPosition();

      // Cek lokasi palsu
      if (position.isMocked) {
        _showError("You are using a fake location.");
        setBusy(false);
        notifyListeners();
        return false;
      }

      // bool isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
      // bool isRealDevice = await JailbreakRootDetection.instance.isRealDevice;

      // if (isNotTrust) {
      //   _showError("Perangkat terdeteksi dalam kondisi rooted/jailbroken.");
      //   setBusy(false);
      //   notifyListeners();
      //   return false;
      // }

      // if (isRealDevice) {
      //   _showError("Perangkat terdeteksi dalam kondisi rooted/jailbroken.");
      //   setBusy(false);
      //   notifyListeners();
      //   return false;
      // }

      // Semua aman
      return true;
    } catch (e) {
      _showError("Terjadi kesalahan saat memeriksa lokasi: $e");
      setBusy(false);
      notifyListeners();
      return false;
    }
  }

  locationCheck() async {
    try {
      setBusy(true);
      Future.delayed(Duration(seconds: 3), () async {
        final cekPermissionLocation = await checkLocationPermission();
        if (!cekPermissionLocation) {
          _showError("location permission not granted");
          setBusy(false);
          notifyListeners();
        } else {
          setLocationName();
          setBusy(false);
          notifyListeners();
        }
      });
    } catch (e) {}
  }

  Future<bool> assigmentLocation() async {
    try {
      final dataAssisgmentLocation = await ApiServices().getAssigmentLocation();
      print("dataAssisgmentLocation : ${dataAssisgmentLocation.listData}");
      if (dataAssisgmentLocation.success == true) {
        if (dataAssisgmentLocation.listData!.isEmpty) {
          _showError('Location not set yet');
          notifyListeners();
          setBusy(false);
          return false;
        } else {
          final cekValidLocation = await isLocationValid();
          if (!cekValidLocation) {
            notifyListeners();
            setBusy(false);
            return false;
          } else {
            await cekRangeLocation(dataAssisgmentLocation.listData!);
            if (foundInRange) {
              // POST ABSEN
              notifyListeners();
              setBusy(false);
              return true;
            } else {
              _showError("You are out of location range");
              setBusy(false);
              notifyListeners();
              return false;
            }
          }
        }
      } else {
        _showError("Failed Assigment Location");
        setBusy(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error assigmentLocation : ${e}");
      setBusy(false);
      return false;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(ctx!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(ctx!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  getAllFunction() async {
    setBusy(true);
    
    await getDataUser();
    await locationCheck();
    await getLeaveSaldo();
    await getDateHoliday();
    setBusy(false);
  }

  @override
  Future futureToRun() async {
    await getAllFunction();
  }
}
