// lib/state/global_loading_state.dart
import 'package:flutter/material.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';

class GlobalLoadingState with ChangeNotifier {
  bool _isLoading = false;
  int lengthApproveRequest = 0;

  int get getlengthApproveRequestVariabel => lengthApproveRequest;
  bool get isLoading => _isLoading;

  getLengthApproveRequest() async {
    final datas = await ApiServices().getListApproveRequest();
    lengthApproveRequest = datas.listData?.length ?? 0;
    notifyListeners();
  }

  void show() {
    _isLoading = true;
    notifyListeners();
  }

  void hide() {
    _isLoading = false;
    notifyListeners();
  }
}
