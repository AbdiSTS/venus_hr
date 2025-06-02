import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:venus_hr_psti/page/home/permission/permision_viewmodel.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/custom_range_date.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/rounded_clipper.dart';
import '../../../core/components/search_dropdwon.dart';
import '../../../core/components/spaces.dart';
import 'package:stacked/stacked.dart';

import '../../../core/components/styles.dart';

class PermisionView extends StatefulWidget {
  const PermisionView({super.key});

  @override
  State<PermisionView> createState() => _PermisionViewState();
}

class _PermisionViewState extends State<PermisionView> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => PermisionViewmodel(ctx: context),
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
                                        "Permission",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Permission Type",
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
                                              items: vm.datalistTypeNusantara,
                                              label:
                                                  'Search Permission Request',
                                              padding: EdgeInsets.zero,
                                              // searchBarHeight: SDP.sdp(40),
                                              hint: 'Permission Request',
                                              dropdownHintText:
                                                  'Cari Permission Request',
                                              dropdownItemStyle:
                                                  GoogleFonts.getFont("Lato"),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  vm.selectTypePermission =
                                                      value['TypeLangguage'];
                                                }
                                              },
                                              dropDownMenuItems: vm
                                                  .datalistTypeNusantara
                                                  .map((e) {
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
                                                        .formatDate(
                                                            selectedDate)
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
                                                        .formatDate(
                                                            selectedDate)
                                                        .toString();
                                                  });

                                                  // fromDate = selectedDate;
                                                }),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12.0),
                                      Text("Permission Request",
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
                                                    vm.selectPermissionRequest =
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
                                      Text("Attachments",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      const SizedBox(height: 12.0),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: vm.imageFiles.isEmpty
                                            ? GestureDetector(
                                                onTap: () async {
                                                  await vm.pickImage();
                                                  print("klik");
                                                },
                                                child: DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  color: Colors.grey,
                                                  radius: const Radius.circular(
                                                      18.0),
                                                  dashPattern: const [8, 4],
                                                  child: Center(
                                                    child: SizedBox(
                                                      height: 120.0,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Assets.icons.image
                                                              .svg(),
                                                          const SpaceHeight(
                                                              18.0),
                                                          const Text(
                                                              'Lampiran'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : DottedBorder(
                                                borderType: BorderType.RRect,
                                                color: Colors.grey,
                                                radius:
                                                    const Radius.circular(18.0),
                                                dashPattern: const [8, 4],
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(18.0),
                                                  ),
                                                  child: GridView.builder(
                                                    shrinkWrap:
                                                        true, // penting jika tidak berada dalam Expanded
                                                    physics:
                                                        const NeverScrollableScrollPhysics(), // biar tidak tabrakan scroll
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 4.0,
                                                      mainAxisSpacing: 4.0,
                                                    ),
                                                    itemCount:
                                                        vm.imageFiles.length +
                                                            1,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (index ==
                                                          vm.imageFiles
                                                              .length) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              await vm
                                                                  .pickImage();
                                                            },
                                                            child: Image.asset(
                                                              "assets/images/add_image.png",
                                                              height: 50,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Stack(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                                child:
                                                                    Image.file(
                                                                  vm.imageFiles[
                                                                      index],
                                                                  height: 120.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    vm.imageFiles
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
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
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            if (vm.selectTypePermission ==
                                                    null ||
                                                vm.selectPermissionRequest ==
                                                    null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                    "Field cannot be empty"),
                                                backgroundColor: Colors.red,
                                              ));
                                            } else {
                                              FocusScope.of(context).unfocus();
                                              vm.postPermission();
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
