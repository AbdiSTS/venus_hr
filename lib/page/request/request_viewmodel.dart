import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/core/constants/colors.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';
import 'package:venus_hr_psti/state_global/state_global.dart';
import 'package:provider/provider.dart';

class RequestViewmodel extends FutureViewModel {
  BuildContext? ctx;
  RequestViewmodel({this.ctx});
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
       ctx!.read<GlobalLoadingState>().getLengthApproveRequest();
      listApproveRequest = List.from(response.listData!);
      listApproveRequestSearch = List.from(response.listData!);
      notifyListeners();
      setBusy(false);
    } else {
      notifyListeners();
      setBusy(false);
    }
  }

  updateRequest(
      String employeeId, String tranNo, String tranName, String status) async {
    try {
      setBusy(true);
      final response = await ApiServices()
          .updateRequest(employeeId, tranNo, tranName, status);

      if (response.success == true) {
       
        ScaffoldMessenger.of(ctx!).showSnackBar(
          SnackBar(
            content: Text("${response.message}"),
            backgroundColor: AppColors.green,
          ),
        );
        await getListApproveRequest();

        setBusy(false);
        notifyListeners();
      } else {
        ScaffoldMessenger.of(ctx!).showSnackBar(
          SnackBar(
            content: Text("${response.message}"),
            backgroundColor: AppColors.red,
          ),
        );

        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text("${e}"),
          backgroundColor: AppColors.red,
        ),
      );
      print("error : ${e}");

      setBusy(false);
      notifyListeners();
    }
  }

  cancelRequest(String employeeID, String tranNo, String tranName) async {
    try {
      setBusy(true);
      final response =
          await ApiServices().deleteRequest(employeeID, tranNo, tranName);
      if (response.success == true) {
        await getListMyRequest();
        ScaffoldMessenger.of(ctx!).showSnackBar(
          SnackBar(
            content: Text("${response.message}"),
            backgroundColor: AppColors.green,
          ),
        );

        setBusy(false);
        notifyListeners();
      } else {
        ScaffoldMessenger.of(ctx!).showSnackBar(
          SnackBar(
            content: Text("${response.message}"),
            backgroundColor: AppColors.green,
          ),
        );

        setBusy(false);
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx!).showSnackBar(
        SnackBar(
          content: Text("${e}"),
          backgroundColor: AppColors.green,
        ),
      );

      setBusy(false);
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {
    await getListMyRequest();
    await getListApproveRequest();
  }
}
