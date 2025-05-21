import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';

import '../../core/assets/assets.gen.dart';
import '../../core/constants/colors.dart';

class HomeView2 extends StatefulWidget {
  const HomeView2({super.key});

  @override
  State<HomeView2> createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Assets.images.bgHome.provider(),
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black
                            .withOpacity(0.7), // Warna bayangan (opsional)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Radius sudut card (opsional)
                        ),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  DateTime.now().toFormattedTime(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 92, 92, 92),
                                  ),
                                ),
                                Text(
                                  "${DateTime.now().toFormattedDate()}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(158, 0, 0, 0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: Center(
                                        child: AutoSizeText(
                                          "Jl. Benyamin Suaeb No.13, RT.13/RW.6, Kebon Kosong",
                                          maxLines: 4,
                                          minFontSize: 10,
                                          stepGranularity: 10,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lato(
                                            color: Color.fromARGB(120, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
