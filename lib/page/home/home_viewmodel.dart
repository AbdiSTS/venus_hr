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

import '../../core/constants/colors.dart';
import '../../data/models/list_dynamic_model.dart';
import '../../state_global/state_global.dart';

class HomeViewmodel extends FutureViewModel {
  BuildContext? ctx;
  HomeViewmodel({this.ctx});
  ResponseResult? dataUser;

  LatLng? currentLocation;
  String? address;
  String? namaJalan;

  ListDynamicModel? listSaldoLeave;

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

  checkLocationPermission() async {
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

  getAddressLocation() async {
    try {
      setBusy(true);
      final cekLocations = await checkLocationPermission();
      if (cekLocations == true) {
        final positionFake = await Geolocator.getCurrentPosition();
        if (positionFake.isMocked) {
          ScaffoldMessenger.of(ctx!).showSnackBar(
            const SnackBar(
              content: Text('Anda menggunakan lokasi palsu'),
              backgroundColor: AppColors.red,
            ),
          );
        } else {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          currentLocation = LatLng(position.latitude, position.longitude);

          List<Placemark> placemarks = await placemarkFromCoordinates(
              currentLocation!.latitude, currentLocation!.longitude);
          Placemark placemark = placemarks[0];
          address =
              "${placemark.street}, ${placemark.name}, ${placemark.subLocality}, ${placemark.postalCode}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
          namaJalan = "${placemark.street}";
          setBusy(false);
          notifyListeners();
        }
      } else {
        namaJalan = 'location permission not granted';
        setBusy(false);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      setBusy(false);
      notifyListeners();
    } catch (e) {
      setBusy(false);
      notifyListeners();
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

  getAllFunction() async {
    setBusy(true);
    await getDataUser();
    await getAddressLocation();
    await getLeaveSaldo();
    setBusy(false);
  }

  @override
  Future futureToRun() async {
    await getAllFunction();
  }
}
