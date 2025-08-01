import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/components/card_list_approve_request.dart';
import 'package:venus_hr_psti/core/components/dotten_vertical.dart';
import 'package:venus_hr_psti/core/extensions/extensions.dart';
import 'package:venus_hr_psti/page/request/request_viewmodel.dart';

import 'custom_text_field.dart';
import 'smart_image.dart';

class CardListRequest extends StatefulWidget {
  RequestViewmodel? vm;
  CardListRequest({
    Key? key,
    this.vm,
  });

  @override
  State<CardListRequest> createState() => _CardListRequestState();
}

class _CardListRequestState extends State<CardListRequest> {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      name: "Rp.",
      decimalDigits: 0,
    );
    return RefreshIndicator(
        onRefresh: () async {
          await widget.vm!.getListMyRequest();
        },
        child: widget.vm?.listMyRequest == []
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Data Is Empty")),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  75, 0, 0, 0), // Warna border
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                widget.vm?.searchControllerMyRequest?.text =
                                    value;
                                widget.vm?.onSearchTextChangedMyRequest(value);
                              });
                            },
                            controller: widget.vm?.searchControllerMyRequest,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search ...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      widget.vm?.searchControllerMyRequest
                                          ?.clear();
                                      widget.vm
                                          ?.onSearchTextChangedMyRequest('');
                                    });
                                  },
                                )),
                          ),
                        ),
                      ),
                      Column(
                          children: widget.vm?.listMyRequest.map((e) {
                                String? pisahkoma =
                                    e['Notes'].split('.').toString();
                                String? pisahkoma2 =
                                    e['Notes'].split(',').toString();
                                List<dynamic> listImage =
                                    e['FileNames'].toString().split('|');

                                final notesParts = e['TranName'] == 'Overtime'
                                    ? e['Notes'].toString().split('-')
                                    : [];

                                final startDate = e['TranName'] == 'Overtime'
                                    ? DateFormat('MM/dd/yyyy HH:mm:ss')
                                        .parse(notesParts[0].trim())
                                    : DateTime.now();
                                final endDate = e['TranName'] == 'Overtime'
                                    ? DateFormat('MM/dd/yyyy HH:mm:ss')
                                        .parse(notesParts[1].trim())
                                    : DateTime.now();

                                final duration = endDate.difference(startDate);

                                final hours = duration.inHours;
                                final minutes =
                                    duration.inMinutes.remainder(60);
                                final seconds =
                                    duration.inSeconds.remainder(60);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            75, 0, 0, 0), // Warna garis border
                                        width: 0.5, // Ketebalan garis border
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${e['TranName']}",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  WidgetStatePropertyAll(
                                                            Colors.red,
                                                          )),
                                                          onPressed: () {
                                                            print(
                                                                "employeeID : ${e['EmployeeID']}");
                                                            print(
                                                                "tranNo : ${e['TranNo']}");
                                                            print(
                                                                "tranName : ${e['TranName']}");

                                                            widget.vm?.cancelRequest(
                                                                e['EmployeeID'],
                                                                e['TranNo'],
                                                                e['TranName']);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: GoogleFonts
                                                                .lato(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 11,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: const Color.fromARGB(
                                                      86, 0, 0, 0),
                                                ),
                                                Container(
                                                  color: const Color.fromARGB(
                                                      13, 158, 158, 158),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          child: DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black),
                                                            child: SizedBox(
                                                                width: 2),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${e['TranType']}",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            e['TranName'] ==
                                                                    "Loan"
                                                                ? Text(
                                                                    "${formatCurrency.format(int.parse(pisahkoma.toString()))} / ${pisahkoma2}",
                                                                    style: GoogleFonts.lato(
                                                                        fontSize:
                                                                            12,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            125,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                                  )
                                                                : e['TranName'] ==
                                                                            "Permission" ||
                                                                        e['TranName'] ==
                                                                            "Leave"
                                                                    ? Text(
                                                                        "${DateFormat('MM/dd/yyyy').parse('${e['Notes'].toString().split('-')[0].trim()}').toFormattedDateDays()} - ${DateFormat('MM/dd/yyyy').parse('${e['Notes'].toString().split('-')[1].trim()}').toFormattedDateDays()}",
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                11,
                                                                            color: const Color.fromARGB(
                                                                                125,
                                                                                0,
                                                                                0,
                                                                                0)),
                                                                      )
                                                                    : e['TranName'] ==
                                                                            "Overtime"
                                                                        ? Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${DateFormat('MM/dd/yyyy').parse('${e['Notes'].toString().split('-')[0].trim()}').toFormattedDateDays()} - ${DateFormat('MM/dd/yyyy').parse('${e['Notes'].toString().split('-')[1].trim()}').toFormattedDateDays()}",
                                                                                style: GoogleFonts.lato(fontSize: 11, color: const Color.fromARGB(125, 0, 0, 0)),
                                                                              ),
                                                                              Text(
                                                                                "(${DateFormat('HH:mm:ss').format(DateFormat('MM/dd/yyyy HH:mm:ss').parse('${e['Notes'].toString().split('-')[0].trim()}'))} - ${DateFormat('HH:mm:ss').format(DateFormat('MM/dd/yyyy HH:mm:ss').parse('${e['Notes'].toString().split('-')[1].trim()}'))}) | Duration: ${hours > 0 ? '$hours Hour ' : ''}${minutes > 0 ? '$minutes minute' : ''}",
                                                                                style: GoogleFonts.lato(fontSize: 11, color: const Color.fromARGB(125, 0, 0, 0)),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Text(
                                                                            "${e['Notes']}",
                                                                            style:
                                                                                GoogleFonts.lato(fontSize: 12, color: const Color.fromARGB(125, 0, 0, 0)),
                                                                          )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: const Color
                                                          .fromARGB(75, 0, 0,
                                                          0), // Warna garis border
                                                      width:
                                                          0.5, // Ketebalan garis border
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "${e['Requester'] ?? '-'}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "(Requester)",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                            child:
                                                                DottedVerticalLine(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "${e['ApprovedBy'] == '' || e['ApprovedBy'] == null ? '-' : e['ApprovedBy']}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "(Approved By)",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Reason : ",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${e['Reason'] == '' || e['Reason'] == null ? '-' : e['Reason']}",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                            e['TranName'] ==
                                                                    'Permission'
                                                                ? e['FileNames'] !=
                                                                        '-'
                                                                    ? ExpansionTile(
                                                                        leading:
                                                                            const Icon(Icons.folder),
                                                                        title: const Text(
                                                                            'Attachment'),
                                                                        trailing:
                                                                            const Icon(Icons.expand_more), // default sudah ada panah
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                150,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                GridView.builder(
                                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                crossAxisCount: 3,
                                                                                crossAxisSpacing: 4.0,
                                                                                mainAxisSpacing: 4.0,
                                                                              ),
                                                                              itemCount: listImage.length,
                                                                              itemBuilder: (context, index) {
                                                                                // print("imageString[index]  : ${imageString[index]}");
                                                                                return Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: ClipRRect(
                                                                                          borderRadius: const BorderRadius.all(
                                                                                            Radius.circular(10),
                                                                                          ),
                                                                                          child: SmartImage(filename: listImage[index])),
                                                                                    ),
                                                                                    // InkWell(
                                                                                    //     onTap: () {
                                                                                    //       setState(() {
                                                                                    //         imageFiles.removeAt(index);
                                                                                    //       });
                                                                                    //     },
                                                                                    //     child: Icon(Icons.cancel)),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Stack()
                                                                : Stack(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList() ??
                              []),
                    ],
                  ),
                ),
              ));
  }
}
