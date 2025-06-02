import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/components/card_list_approve_request.dart';
import 'package:venus_hr_psti/core/components/dotten_vertical.dart';
import 'package:venus_hr_psti/core/extensions/extensions.dart';
import 'package:venus_hr_psti/page/history/history_viewmodel.dart';
import 'package:venus_hr_psti/page/request/request_viewmodel.dart';

import 'custom_text_field.dart';
import 'smart_image.dart';

class CardListHistoryRequest extends StatefulWidget {
  HistoryViewmodel? vm;
  CardListHistoryRequest({
    Key? key,
    this.vm,
  });

  @override
  State<CardListHistoryRequest> createState() => _CardListHistoryRequestState();
}

class _CardListHistoryRequestState extends State<CardListHistoryRequest> {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'id_ID',
      name: "Rp.",
      decimalDigits: 0,
    );
    return RefreshIndicator(
        onRefresh: () async {},
        child: widget.vm?.listHistoryRequest == []
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
                                widget.vm?.searchControllerHistoryRequest.text =
                                    value;
                                widget.vm
                                    ?.onSearchTextChangedHistoryRequest(value);
                              });
                            },
                            controller:
                                widget.vm?.searchControllerHistoryRequest,
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
                                      widget.vm?.searchControllerHistoryRequest
                                          .clear();
                                      widget.vm
                                          ?.onSearchTextChangedHistoryRequest(
                                              '');
                                    });
                                  },
                                )),
                          ),
                        ),
                      ),
                      Column(
                          children: widget.vm?.listHistoryRequest.map((e) {
                                String? pisahkoma =
                                    e['Notes'].split('.').toString();
                                String? pisahkoma2 =
                                    e['Notes'].split(',').toString();
                                List<dynamic> listImage =
                                    e['FileNames'].toString().split('|');

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
                                                                    : Text(
                                                                        "${e['Notes']}",
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            color: const Color.fromARGB(
                                                                                125,
                                                                                0,
                                                                                0,
                                                                                0)),
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
                                                                  "${e['ApprovedName'] == '' || e['ApprovedName'] == null ? '-' : e['ApprovedName']}",
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
