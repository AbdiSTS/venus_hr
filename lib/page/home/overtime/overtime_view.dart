import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/core/components/styles.dart';
import 'package:venus_hr_psti/page/home/overtime/overtime_viewmodel.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_date_picker.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/search_dropdwon.dart';
import '../../../core/components/spaces.dart';

class OvertimeView extends StatefulWidget {
  const OvertimeView({super.key});

  @override
  State<OvertimeView> createState() => _OvertimeViewState();
}

class _OvertimeViewState extends State<OvertimeView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => OvertimeViewmodel(ctx: context),
        builder: (context, vm, child) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
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
                                        "Overtime",
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
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Overtime Type",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      const SizedBox(height: 12.0),
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomSearchableDropDown(
                                              isReadOnly: false,
                                              items: vm.listOvertimeType,
                                              label: 'Search Overtime Type',
                                              padding: EdgeInsets.zero,
                                              // searchBarHeight: SDP.sdp(40),
                                              hint: 'Overtime Type',
                                              dropdownHintText:
                                                  'Cari Overtime Type',
                                              dropdownItemStyle:
                                                  GoogleFonts.getFont("Lato"),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    vm.selectedOvertimeTypeCode =
                                                        value['OTTypeCode'];
                                                    vm.selectedOvertimeTypeName =
                                                        value['OTTypeName'];
                                                  });
                                                }
                                              },
                                              dropDownMenuItems:
                                                  vm.listOvertimeType.map((e) {
                                                return '${e['OTTypeName']}';
                                              }).toList()),
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                      CustomDatePicker(
                                          label: 'Overtime Date',
                                          onDateSelected: (selectedDate) {
                                            setState(() {
                                              vm.overtimeDate?.text = vm
                                                  .formatDate(selectedDate)
                                                  .toString();

                                              print("overtime date : ${vm.overtimeDate?.text}");
                                            });
                                          }),
                                      const SizedBox(height: 12.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Time From",
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                const SizedBox(height: 12.0),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Field cannot be empty';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      vm.timeFromController,
                                                  onTap: () async {
                                                    final TimeOfDay? time =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                vm.selectedTimeTo ??
                                                                    TimeOfDay
                                                                        .now());
                                                    setState(() {
                                                      vm.selectedTimeFrom =
                                                          time;
                                                      vm.timeFromController
                                                              ?.text =
                                                          "${vm.selectedTimeFrom!.format(context).substring(0, 5)}";
                                                      ;
                                                    });
                                                  },
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Assets
                                                          .icons.calendar
                                                          .svg(),
                                                    ),
                                                    hintText:
                                                        vm.selectedTimeFrom !=
                                                                null
                                                            ? vm.selectedTimeFrom
                                                                ?.format(
                                                                    context)
                                                                .substring(0, 5)
                                                            : "Time From",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Time To",
                                                    style: GoogleFonts.lato(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                                const SizedBox(height: 12.0),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Field cannot be empty';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      vm.timeToController,
                                                  onTap: () async {
                                                    final TimeOfDay? time =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                vm.selectedTimeTo ??
                                                                    TimeOfDay
                                                                        .now());
                                                    setState(() {
                                                      vm.selectedTimeTo = time;
                                                      vm.timeToController
                                                              ?.text =
                                                          "${vm.selectedTimeTo!.format(context).substring(0, 5)}";
                                                      ;
                                                    });
                                                  },
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Assets
                                                          .icons.calendar
                                                          .svg(),
                                                    ),
                                                    hintText:
                                                        vm.selectedTimeTo !=
                                                                null
                                                            ? vm.selectedTimeTo
                                                                ?.format(
                                                                    context)
                                                                .substring(0, 5)
                                                            : "Time To",
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                          border:
                                              Border.all(color: Colors.grey),
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
                                                    vm.selectApproval =
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
                                      const SpaceHeight(26.0),
                                      Button.filled(
                                        onPressed: () {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            if (vm.selectedOvertimeTypeCode ==
                                                    null ||
                                                vm.overtimeDate?.text == null ||
                                                vm.selectApproval == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    "Field cannot be empty"),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              FocusScope.of(context).unfocus();
                                              vm.postOvertime();
                                            }
                                          }
                                        },
                                        label: 'Create',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
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
              ));
        });
  }
}
