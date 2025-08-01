import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:venus_hr_psti/core/components/card_list_approve_request.dart';
import 'package:venus_hr_psti/page/request/request_viewmodel.dart';

import '../../core/components/card_list_request.dart';
import '../../core/components/rounded_clipper.dart';
import 'package:stacked/stacked.dart';

import '../../core/components/styles.dart';
import '../../state_global/state_global.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;
  int selectedIndexType = 0;

  final List<String> tabs = ['My Request', 'Approval Request'];

  final List<String> tranType = [
    'All',
    'Permission',
    'Leave',
    'Claim',
    'Overtime',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => RequestViewmodel(ctx: context),
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
                            "Request",
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
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(tabs.length, (index) {
                              bool isSelected = selectedIndex == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedIndex = index),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        tabs[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(tranType.length, (index) {
                              bool isSelected = selectedIndexType == index;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                        isSelected
                                            ? const Color.fromARGB(
                                                255, 98, 155, 255)
                                            : Colors.white,
                                      )),
                                      onPressed: () {
                                        setState(() {
                                          selectedIndexType = index;
                                          if (selectedIndex == 0) {
                                            vm.onSearchTextChangedMyRequest(
                                                '${tranType[index]}');
                                          } else {
                                            vm.onSearchTextChangedAppRequest(
                                                '${tranType[index]}');
                                          }
                                        });
                                      },
                                      child: Text(
                                        tranType[index],
                                        style: GoogleFonts.lato(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: isSelected ? 13 : 11,
                                        ),
                                      ),
                                    )),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: selectedIndex,
                            children: [
                              CardListRequest(
                                vm: vm,
                              ),
                              CardListApproveRequest(
                                vm: vm,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}
