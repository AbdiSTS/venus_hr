import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';

class RequestViewmodel extends FutureViewModel {
  List<dynamic> listMyRequest = [];
  List<dynamic> listMyRequestSearch = [];

  List<dynamic> listApproveRequest = [];
  List<dynamic> listApproveRequestSearch = [];

  TextEditingController? searchControllerMyRequest =
      new TextEditingController();
  TextEditingController? searchControllerApprovedRequest =
      new TextEditingController();

  void onSearchTextChangedMyRequest(String text) {
    listMyRequest = text.isEmpty || text == 'All'
        ? listMyRequestSearch
        : listMyRequestSearch
            .where((item) =>
                item['TranName']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['TranNo']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['EmployeeID']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['Requester']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['Approver']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
            .toList();

    notifyListeners();
  }

  void onSearchTextChangedAppRequest(String text) {
    listApproveRequest = text.isEmpty || text == 'All'
        ? listApproveRequestSearch
        : listApproveRequestSearch
            .where((item) =>
                item['TranName']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['TranNo']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['EmployeeID']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['Requester']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                item['Approver']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
            .toList();

    notifyListeners();
  }

  getListMyRequest() async {
    setBusy(true);
    final response = await ApiServices().getListMyRequest();

    if (response.success == true) {
      listMyRequest = List.from(response.listData!);
      listMyRequestSearch = List.from(response.listData!);
      print("listMyRequest : ${listMyRequest}");
      notifyListeners();
      setBusy(false);
    } else {
      notifyListeners();
      setBusy(false);
    }
  }

  getListApproveRequest() async {
    setBusy(true);
    final response = await ApiServices().getListApproveRequest();

    if (response.success == true) {
      listApproveRequest = List.from(response.listData!);
      listApproveRequestSearch = List.from(response.listData!);
      print("listApproveRequest : ${listApproveRequest}");
      notifyListeners();
      setBusy(false);
    } else {
      notifyListeners();
      setBusy(false);
    }
  }

  @override
  Future futureToRun() async {
    await getListMyRequest();
    await getListApproveRequest();
  }
}
