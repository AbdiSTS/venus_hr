import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/card_list_request.dart';
import '../../core/components/rounded_clipper.dart';
import '../../core/components/search_dropdwon.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  TextEditingController _dateFromController = TextEditingController();
  TextEditingController _dateToController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // batas bawah
      lastDate: DateTime(2101), // batas atas
    );
    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        controller.text = formattedDate;
      });
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
        onTap: () => _selectDate(context, controller),
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
  final List<String> tranType = [
    'All',
    'Permission',
    'Leave',
    'Claim',
    'Overtime',
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: ClipPath(
                clipper: BottomRoundedClipper(),
                child: Container(
                  color: Colors.blueAccent,
                  child: Center(
                    child: Text(
                      "History",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
          Expanded(
            flex: 10,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Form(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: buildDateField(
                                    "Date From", _dateFromController)),
                            Expanded(
                                flex: 2,
                                child: buildDateField(
                                    "Date To", _dateToController)),
                          ],
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
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
                                  items: [],
                                  label: 'Search History Type',
                                  padding: EdgeInsets.zero,
                                  // searchBarHeight: SDP.sdp(40),
                                  hint: 'History Type',
                                  dropdownHintText: 'Cari History Type',
                                  dropdownItemStyle:
                                      GoogleFonts.getFont("Lato"),
                                  onChanged: (value) {
                                    if (value != null) {
                                      // selectedHistoryType = value;
                                    }
                                  },
                                  dropDownMenuItems: []),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                Colors.blueAccent,
                              )),
                              onPressed: () {},
                              child: Icon(
                                color: Colors.white,
                                Icons.search,
                              ),
                            ))
                      ],
                    ),
                    Expanded(
                      child: CardListRequest(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
