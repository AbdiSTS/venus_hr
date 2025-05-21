import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_range_date.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/search_dropdwon.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  TextEditingController? reasonController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: BottomRoundedClipper(),
                    child: Container(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          "Leave",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16, // posisi dari kiri
                    top: 5,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/back.svg",
                          color: Colors.white,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Leave Type",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchableDropDown(
                              isReadOnly: false,
                              items: [],
                              label: 'Search Leave Type',
                              padding: EdgeInsets.zero,
                              // searchBarHeight: SDP.sdp(40),
                              hint: 'Leave Type',
                              dropdownHintText: 'Cari Leave Type',
                              dropdownItemStyle: GoogleFonts.getFont("Lato"),
                              onChanged: (value) {
                                if (value != null) {
                                  // permissionType = value;
                                  // print(
                                  //     "value : ${value}, permissionType!.TypeLangguage : ${permissionType!.TypeLangguage} ");
                                }
                              },
                              dropDownMenuItems: []),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text("Leave Duration",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchableDropDown(
                              isReadOnly: false,
                              items: [],
                              label: 'Search Leave Duration',
                              padding: EdgeInsets.zero,
                              // searchBarHeight: SDP.sdp(40),
                              hint: 'Leave Duration',
                              dropdownHintText: 'Cari Leave Duration',
                              dropdownItemStyle: GoogleFonts.getFont("Lato"),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    // print("valuee: ${value}");
                                    // print("selectLeaveType?.type : ${selectLeaveType}");
                                  });
                                }
                              },
                              dropDownMenuItems: []),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomDatePickerRange(
                                label: 'From Date',
                                startDate: DateTime(2025, 01, 01),
                                onDateSelected: (selectedDate) {
                                  // fromdatePermissionController?.text =
                                  //     formatDate(selectedDate).toString();

                                  // fromDate = selectedDate;
                                }),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomDatePickerRange(
                                label: 'To Date',
                                // beforeDate: from,
                                startDate: DateTime(2025, 01, 01),
                                onDateSelected: (selectedDate) {
                                  // fromdatePermissionController?.text =
                                  //     formatDate(selectedDate).toString();

                                  // fromDate = selectedDate;
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text("Approval",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 12.0),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchableDropDown(
                              isReadOnly: false,
                              items: [],
                              label: 'Search Approvel',
                              padding: EdgeInsets.zero,
                              // searchBarHeight: SDP.sdp(40),
                              hint: 'Search Approvel',
                              dropdownHintText: 'Cari Search Approvel',
                              dropdownItemStyle: GoogleFonts.getFont("Lato"),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    // selectApprovel = value['EmployeeID'];
                                  });
                                }
                              },
                              dropDownMenuItems: []),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      CustomTextField(
                        controller: reasonController!,
                        label: 'Reason',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12.0),
                      Button.filled(
                        onPressed: () {},
                        label: 'Create',
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
