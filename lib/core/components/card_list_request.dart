import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardListRequest extends StatefulWidget {
  const CardListRequest({super.key});

  @override
  State<CardListRequest> createState() => _CardListRequestState();
}

class _CardListRequestState extends State<CardListRequest> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Permission",
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Card(
                                        color: Colors.orange,
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Text(
                                            "On Process",
                                            style: GoogleFonts.lato(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: const Color.fromARGB(86, 0, 0, 0),
                                  ),
                                  Container(
                                    color:
                                        const Color.fromARGB(13, 158, 158, 158),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: Colors.black),
                                              child: SizedBox(width: 2),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Izin Sakit",
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "02/25/2025 - 02/25/2025",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: const Color.fromARGB(
                                                        125, 0, 0, 0)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Boim"),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
