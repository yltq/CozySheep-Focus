import 'package:flutter/material.dart';
import 'package:listen_bleat/bleat_info1/FocusAndModeRecord.dart';
import 'package:listen_bleat/bleat_info1/FocusInfo.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:listen_bleat/info_store1/InfoStore.dart';

import '../component/Image.dart';
import '../component/Text.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<FocusInfo> focusInfoList = [];
  void back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchFocusHistoryInfo();
  }

  void fetchData() async {
    await fetchFocusHistoryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, top: 18, bottom: 18),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: buildImage('${PAGE_ADD}/back'),
                  ),
                ),
                onTap: () {
                  back();
                },
              ),

              buildText('Focus History', Color(0xFF2C2B49), 18,
                  fontWeight: FontWeight.bold),

              Spacer(flex: 1,)
            ],
          ),

          SizedBox(height: 10,),

          Expanded(child: buildHistoryList())
        ],
      ),
    ), onWillPop: () async {
      back();
      return false;
    });
  }

  Future<List<FocusInfo>> fetchFocusHistoryInfo() async {
    List<FocusInfo> list = await InfoStore.hqFocusRecord();
    setState(() {
      focusInfoList = list;
    });
    return list;
  }

  Widget buildEmpty() {
    return Column(
      children: [
        Spacer(flex: 1,),
        SizedBox(
          width: 138,
          height: 138,
          child: buildImage('${PAGE_MAIN_TAB}/statistics_empty'),
        ),
        SizedBox(height: 20,),
        buildText('Your list is empty', Color(0xFFC3C3C3), 12),
        SizedBox(height: 52,),

        GestureDetector(
          child: Container(
            height: 52,
            width: 272,
            decoration: BoxDecoration(
                color: Color(0xFF5099B5),
                borderRadius: BorderRadius.circular(75)
            ),
            child: Center(
              child: buildText('Add new', Colors.white, 16),
            ),
          ),
          onTap: () {
              Navigator.popAndPushNamed(context, PAGE_ADD);
          },
        ),


        Spacer(flex: 1,),
      ],
    );
  }


  Widget buildHistoryList() {
    return Stack(
      children: [
          Visibility(visible: focusInfoList.isEmpty,child:  buildEmpty(),),
          Visibility(visible: focusInfoList.isNotEmpty,child: Container(
            child: ListView.builder(
                itemCount: focusInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  FocusInfo info = focusInfoList[index];
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 20, left: 28, right: 28),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth(context),
                      height: 74,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFFF1F1F1), width: 1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Expanded(child: Column(
                            children: [
                              Spacer(flex: 1,),
                              buildText("Focus", Color(0xFF525252), 12),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  buildText(
                                      info.focusSuccessNumber.toString(),
                                      Color(0xFF2C2B49),
                                      16,
                                      fontWeight: FontWeight.bold),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  buildText(
                                      '(${secondsToOtherTimeStringNoFH(
                                          info.focusSuccessTime)})',
                                      Color(0xFFC3C3C3),
                                      14,
                                      fontWeight: FontWeight.bold),
                                  Spacer(flex: 1,),
                                ],
                              ),
                              Spacer(flex: 1,),
                            ],
                          )),

                          SizedBox(width: 10,),

                          Expanded(child: Column(
                            children: [
                              Spacer(flex: 1,),
                              buildText("Failure", Color(0xFF525252), 12),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  buildText(
                                      info.focusFailureNumber.toString(),
                                      Color(0xFF2C2B49),
                                      16,
                                      fontWeight: FontWeight.bold),
                                  Spacer(flex: 1,),
                                ],
                              ),
                              Spacer(flex: 1,),
                            ],
                          )),

                          SizedBox(width: 10,),

                          SizedBox(width: 80, child: buildText('${info.date}>', Color(0xFF5099B5), 10),)
                        ],
                      ),
                    ),
                    onTap: () {
                      showBottomHistoryDetails(info);
                    },
                  );
                }),
          ),)
      ],
    );
  }


  void showBottomHistoryDetails(FocusInfo info) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: 472,
                  width: screenWidth(context),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12,),
                      Row(
                        children: [
                          SizedBox(width: 20,),
                          buildText(
                              '${info.date} Details', Color(0xFF2C2B49), 15),
                          Spacer(flex: 1,)
                        ],
                      ),

                      SizedBox(height: 28,),

                      if(info.modes != null && info.modes!.length > 0)
                        Expanded(child: Container(
                          child: ListView.builder(
                              itemCount: info.modes!.length,
                              padding: EdgeInsets.only(bottom: 54),
                              itemBuilder: (BuildContext context, int index) {
                                FocusAndModeRecord record = info.modes![index];
                                FocusModeInfo? mode = record.mode;
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: 16, left: 20, right: 20),
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  width: screenWidth(context),
                                  height: 74,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFF1F1F1), width: 1),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                          child: SizedBox(
                                            width: 28, height: 28,
                                            child: buildImage(
                                                fetchBackgroundMusicBg(mode == null? 0 : mode.backgroundMusicIndex)),
                                          )
                                      ),

                                      SizedBox(width: 12,),

                                      SizedBox(width: 90, child: buildText(mode == null? '' : mode!.name, Color(0xFF2C2B49), 14),),
                                      SizedBox(width: 12,),

                                      buildText(record.focusSuccess? 'Success' : 'Failure', Color(record.focusSuccess? 0xFF1EC691 : 0xFFEE8D1A), 14),

                                      Spacer(flex: 1,),

                                      buildText(secondsToOtherTimeString(record.focusSuccess? record.focusSuccessTime : record.focusFailureTime),
                                          Color(0xFF2C2B49), 14),
                                    ],
                                  ),
                                );
                              }),
                        ))

                    ],
                  ),
                );
              });
        });
  }


}