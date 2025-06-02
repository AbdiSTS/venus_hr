import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venus_hr_psti/page/home/leave/leave_viewmodel.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_range_date.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/search_dropdwon.dart';
import 'package:stacked/stacked.dart';

import '../../../core/components/styles.dart';

class LeaveView extends StatefulWidget {
  const LeaveView({super.key});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LeaveViewmodel(ctx: context),
        builder: (context, vm, child) {
          return Stack(
            children: [
              Scaffold(
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
                            child: Form(
                              key: formKey,
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Padding(
                                      
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomSearchableDropDown(
                                          isReadOnly: false,
                                          items: vm.listLeaveType,
                                          label: 'Search Leave Type',
                                          padding: EdgeInsets.zero,
                                          // searchBarHeight: SDP.sdp(40),
                                          hint: 'Leave Type',
                                          dropdownHintText: 'Cari Leave Type',
                                          dropdownItemStyle:
                                              GoogleFonts.getFont("Lato"),
                                          onChanged: (value) {
                                            if (value != null) {
                                              vm.selectedLeaveType =
                                                  value['LeaveTypeCode'];
                                            }
                                          },
                                          dropDownMenuItems:
                                              vm.listLeaveType.map((e) {
                                            return '${e['LeaveTypeName']}';
                                          }).toList()),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomSearchableDropDown(
                                          isReadOnly: false,
                                          items: vm.datalistDurasi!,
                                          label: 'Search Leave Duration',
                                          padding: EdgeInsets.zero,
                                          // searchBarHeight: SDP.sdp(40),
                                          hint: 'Leave Duration',
                                          dropdownHintText:
                                              'Cari Leave Duration',
                                          dropdownItemStyle:
                                              GoogleFonts.getFont("Lato"),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                vm.selectedLeaveDuration =
                                                    value['type'];
                                              });
                                            }
                                          },
                                          dropDownMenuItems:
                                              vm.datalistDurasi!.map((e) {
                                            return '${e['type']}';
                                          }).toList()),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomDatePickerRange(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                            label: 'From Date',
                                            startDate: DateTime(
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[0]
                                                        .toString() ??
                                                    '2025'),
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[1]
                                                        .toString() ??
                                                    '02'),
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[2]
                                                        .toString() ??
                                                    '12')),
                                            onDateSelected: (selectedDate) {
                                              setState(() {
                                                vm.selectedDateFrom = vm
                                                    .formatDate(selectedDate)
                                                    .toString();
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: CustomDatePickerRange(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Field cannot be empty';
                                              }
                                              return null;
                                            },
                                            label: 'To Date',
                                            startDate: DateTime(
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[0]
                                                        .toString() ??
                                                    '2025'),
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[1]
                                                        .toString() ??
                                                    '02'),
                                                int.parse(vm.getDateFrom
                                                        ?.split(',')[2]
                                                        .toString() ??
                                                    '12')),
                                            onDateSelected: (selectedDate) {
                                              setState(() {
                                                vm.selectedDateTo = vm
                                                    .formatDate(selectedDate)
                                                    .toString();
                                              });

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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomSearchableDropDown(
                                          isReadOnly: false,
                                          items: vm.listApprover,
                                          label: 'Search Approvel',
                                          padding: EdgeInsets.zero,
                                          // searchBarHeight: SDP.sdp(40),
                                          hint: 'Search Approvel',
                                          dropdownHintText:
                                              'Cari Search Approvel',
                                          dropdownItemStyle:
                                              GoogleFonts.getFont("Lato"),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                vm.selectedApprover =
                                                    value['EmployeeID'];
                                              });
                                            }
                                          },
                                          dropDownMenuItems:
                                              vm.listApprover.map((e) {
                                            return '${e['EmployeeName']}';
                                          }).toList()),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  CustomTextField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field cannot be empty';
                                      }
                                      return null;
                                    },
                                    controller: vm.reasonController!,
                                    label: 'Reason',
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 12.0),
                                  Button.filled(
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        if (vm.selectedLeaveType == null ||
                                            vm.selectedApprover == null || vm.selectedLeaveDuration == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text("Field cannot be empty"),
                                            backgroundColor: Colors.red,
                                          ));
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          vm.postLeave();
                                        }
                                      }
                                    },
                                    label: 'Create',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              vm.isBusy
                  ? Stack(
                      children: [
                        ModalBarrier(
                          dismissible: false,
                          color: const Color.fromARGB(118, 0, 0, 0),
                        ),
                        Center(
                          child: loadingSpinWhiteSizeBig,
                        ),
                      ],
                    )
                  : Stack()
            ],
          );
        });
  }
}
