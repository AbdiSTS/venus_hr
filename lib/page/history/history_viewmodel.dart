import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/data/datasources/api_services.dart';

class HistoryViewmodel extends FutureViewModel {
  BuildContext? ctx;
  HistoryViewmodel({required this.ctx});

  TextEditingController dateFromController = new TextEditingController();
  TextEditingController dateToController = new TextEditingController();
  TextEditingController searchControllerHistoryRequest =
      new TextEditingController();

  String? selectedHistoryType;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // batas bawah
      lastDate: DateTime(2101), // batas atas
    );
    if (pickedDate != null) {
      String formattedDate = "${DateFormat('MM/dd/yyyy').format(pickedDate)}";
      controller.text = formattedDate;
      notifyListeners();
    }
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Card(
      elevation: 2,
      child: TextFormField(
        validator: (value) {
          if (value == "" || value!.isEmpty) {
            return "Filled Not be Empty";
          }
        },
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(ctx!, controller),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.date_range, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  int selectedIndexType = 0;
  List<dynamic> tranType = [
    {"type": "Permission"},
    {"type": "Leave"},
    {"type": "Overtime"},
    // {"type": "Loan"},
  ];

  List<dynamic> listHistoryRequest = [];
  List<dynamic> listHistoryRequestSearch = [];

  void onSearchTextChangedHistoryRequest(String text) {
    listHistoryRequest = text.isEmpty
        ? listHistoryRequestSearch
        : listHistoryRequestSearch
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

  Future<void> getListHistoryRequest() async {
    setBusy(true);
    final response = await ApiServices().getListHistoryRequest(
        dateFromController.text, dateToController.text, selectedHistoryType!);

    if (response.success == true) {
      listHistoryRequest = List.from(response.listData ?? []);
      listHistoryRequestSearch = List.from(response.listData ?? []);
      print("listHistoryRequest : ${listHistoryRequest}");
      print("listHistoryRequestSearch : ${listHistoryRequestSearch}");
      setBusy(false);
      notifyListeners();
    } else {
      listHistoryRequest = [];
      setBusy(false);
      notifyListeners();
    }
  }

  @override
  Future futureToRun() async {}
}
