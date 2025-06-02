import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:venus_hr_psti/core/components/card_list_history_request.dart';
import 'package:venus_hr_psti/page/history/history_viewmodel.dart';
import 'package:venus_hr_psti/state_global/state_global.dart';
import '../../core/components/card_list_request.dart';
import '../../core/components/rounded_clipper.dart';
import 'package:provider/provider.dart';
import '../../core/components/search_dropdwon.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => HistoryViewmodel(ctx: context),
        builder: (context, vm, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            vm.isBusy
                ? context.read<GlobalLoadingState>().show()
                : context.read<GlobalLoadingState>().hide();
          });
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
                                      child: vm.buildDateField(
                                          "Date From", vm.dateFromController)),
                                  Expanded(
                                      flex: 2,
                                      child: vm.buildDateField(
                                          "Date To", vm.dateToController)),
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
                                        items: vm.tranType,
                                        label: 'Search History Type',
                                        padding: EdgeInsets.zero,
                                        // searchBarHeight: SDP.sdp(40),
                                        hint: 'History Type',
                                        dropdownHintText: 'Cari History Type',
                                        dropdownItemStyle:
                                            GoogleFonts.getFont("Lato"),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              vm.selectedHistoryType =
                                                  value['type'];
                                              print(
                                                  "${vm.selectedHistoryType}");
                                            });
                                          }
                                        },
                                        dropDownMenuItems: vm.tranType
                                            .map((e) => e['type'])
                                            .toList()),
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
                                    onPressed: () {
                                      vm.getListHistoryRequest();
                                    },
                                    child: Icon(
                                      color: Colors.white,
                                      Icons.search,
                                    ),
                                  ))
                            ],
                          ),
                          Expanded(
                            flex: 2,
                            child: CardListHistoryRequest(vm: vm,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
