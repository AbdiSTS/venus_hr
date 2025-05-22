import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController? timeFromController= new TextEditingController();
  TextEditingController? timeToController= new TextEditingController();
  TextEditingController? reasonController = new TextEditingController();

  TimeOfDay? selectedTimeFrom;
  TimeOfDay? selectedTimeTo;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchableDropDown(
                              isReadOnly: false,
                              items: [],
                              label: 'Search Overtime Type',
                              padding: EdgeInsets.zero,
                              // searchBarHeight: SDP.sdp(40),
                              hint: 'Overtime Type',
                              dropdownHintText: 'Cari Overtime Type',
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
                      CustomDatePicker(
                          label: 'Overtime Date',
                          onDateSelected: (selectedDate) {
                            // overtimeDate?.text =
                            //     formatDate(selectedDate).toString();
                          }),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Time From",
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  controller: timeToController,
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: selectedTimeTo ??
                                                TimeOfDay.now());
                                    setState(() {
                                      selectedTimeTo = time;
                                      timeToController?.text =
                                          "${selectedTimeTo!.format(context).substring(0, 5)}";
                                      ;
                                    });
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Assets.icons.calendar.svg(),
                                    ),
                                    hintText: selectedTimeTo != null
                                        ? selectedTimeTo
                                            ?.format(context)
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Time To",
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  controller: timeToController,
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: selectedTimeTo ??
                                                TimeOfDay.now());
                                    setState(() {
                                      selectedTimeTo = time;
                                      timeToController?.text =
                                          "${selectedTimeTo!.format(context).substring(0, 5)}";
                                      ;
                                    });
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Assets.icons.calendar.svg(),
                                    ),
                                    hintText: selectedTimeTo != null
                                        ? selectedTimeTo
                                            ?.format(context)
                                            .substring(0, 5)
                                        : "Time From",
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
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomSearchableDropDown(
                              isReadOnly: false,
                              items: [],
                              label: 'Search Approval',
                              padding: EdgeInsets.zero,
                              // searchBarHeight: SDP.sdp(40),
                              hint: 'Search Approval',
                              dropdownHintText: 'Cari Search Approval',
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
                      const SpaceHeight(26.0),
                      Button.filled(
                        onPressed: () {},
                        label: 'Create',
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
