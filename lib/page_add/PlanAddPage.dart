import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:listen_bleat/component/Image.dart';
import 'package:listen_bleat/component/Text.dart';

import '../info_store1/InfoStore.dart';

class PlanAddPage extends StatefulWidget {
  const PlanAddPage({super.key});

  @override
  State<PlanAddPage> createState() => _PlanAddPageState();
}

class _PlanAddPageState extends State<PlanAddPage> {
  String pageTag = '${PAGE_ADD}/';
  FocusModeInfo info = FocusModeInfo();
  final TextEditingController _modeNameController = TextEditingController(text: '');
  final TextEditingController _focusTimeController = TextEditingController(text: '25');
  final TextEditingController _breakTimeController = TextEditingController(text: '5');
  FocusNode _focusTimeFocusNode = FocusNode();
  FocusNode _breakTimeFocusNode = FocusNode();

  void back() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: buildImage('${pageTag}back'),
                  ),
                ),
                onTap: () {
                  back();
                },
              ),

              buildText('Add Plan', Color(0xFF2C2B49), 18, fontWeight: FontWeight.bold),

              Spacer(flex: 1,)
            ],
          ),

          SizedBox(height: 32,),


          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    SizedBox(width: 16, height: 16, child: buildImage('${pageTag}user')),
                    SizedBox(width: 8,),
                    buildText('Name', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                    SizedBox(width: 16,),

                    Expanded(child: Column(
                      children: [
                        CupertinoTextField(
                            maxLines: null,
                            placeholder:
                            "Enter the name...",
                            controller: _modeNameController,
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            textInputAction: TextInputAction.go,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(
                                color: Color(0xFF339FC8),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                            onChanged: (value) {
                              if (!mounted) return;
                              setState(() {
                                info.name = value;
                              });
                            }),

                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(top: 4),
                          color: Color(0xFFD5D5DB),
                        )
                      ],
                    )),

                    SizedBox(width: 20,)
                  ],
                ),

                SizedBox(height: 30,),

                Row(
                  children: [
                    SizedBox(width: 20,),
                    SizedBox(width: 16, height: 16, child: buildImage('${pageTag}focus')),
                    SizedBox(width: 8,),
                    buildText('Focus Time', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                    SizedBox(width: 16,),

                    Expanded(child: Container(
                      height: 42,
                      child: CupertinoTextField(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD5D5DB), width: 1),
                          ),
                          placeholder: '25',
                          maxLines: null,
                          controller: _focusTimeController,
                          focusNode: _focusTimeFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          textAlign: TextAlign.end,
                          textInputAction: TextInputAction.go,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              color: Color(0xFF339FC8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                          onChanged: (value) {
                            if (!mounted) return;
                            // String time = value.substring(0, value.length -4);
                            setState(() {
                              try {
                                info.focusTime = int.parse(value);
                              } catch(e) {}
                            });
                          },
                        onSubmitted: (v) {
                          FocusScope.of(context).unfocus();
                        },),
                    )),
                    SizedBox(width: 4,),
                    buildText('min', Color(0xFF339FC8), 14),

                    SizedBox(width: 20,)
                  ],
                ),

                SizedBox(height: 42,),

                Row(
                  children: [
                    SizedBox(width: 20,),
                    SizedBox(width: 16, height: 16, child: buildImage('${pageTag}break')),
                    SizedBox(width: 8,),
                    buildText('Break Time', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                    SizedBox(width: 16,),

                    Expanded(child: Container(
                      height: 42,
                      child: CupertinoTextField(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD5D5DB), width: 1),
                          ),
                          placeholder: '5',
                          maxLines: null,
                          textAlign: TextAlign.end,
                          focusNode: _breakTimeFocusNode,
                          controller: _breakTimeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          textInputAction: TextInputAction.go,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              color: Color(0xFF339FC8),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                          onChanged: (value) {
                            if (!mounted) return;
                            // String time = value.substring(0, value.length -4);
                            setState(() {
                              try {
                                info.breakTime = int.parse(value);
                              } catch(e) {}
                            });
                          },
                        onSubmitted: (v) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    )),
                    SizedBox(width: 4,),
                    buildText('min', Color(0xFF339FC8), 14),

                    SizedBox(width: 20,)
                  ],
                ),

                SizedBox(height: 44,),


                Row(
                  children: [
                    SizedBox(width: 20,),
                    SizedBox(width: 16, height: 16, child: buildImage('${pageTag}theme')),
                    SizedBox(width: 8,),
                    buildText('Theme Color', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                    Spacer(flex: 1,)
                  ],
                ),

                SizedBox(height: 12,),


                Row(
                    children: [
                      const SizedBox(width: 32,),
                      Container(
                        width: 48,
                        height: 48,
                        child: GestureDetector(child: Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFE7D2),
                                  borderRadius: BorderRadius.circular(48)
                              ),
                            ),
                            Visibility(visible: info.themeColorIndex == 0,child: Column(
                              children: [
                                Spacer(flex: 1,),
                                Row(
                                  children: [
                                    Spacer(flex: 1,),
                                    SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                  ],
                                )
                              ],
                            ),)
                          ],
                        ), onTap: () {
                          setState(() {
                            info.themeColorIndex = 0;
                          });
                        },),
                      ),
                      Spacer(flex: 1,),
                      Container(
                        width: 48,
                        height: 48,
                        child: GestureDetector(child: Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Color(0xFFCAF2FF),
                                  borderRadius: BorderRadius.circular(48)
                              ),
                            ),
                            Visibility(visible: info.themeColorIndex == 1,child: Column(
                              children: [
                                Spacer(flex: 1,),
                                Row(
                                  children: [
                                    Spacer(flex: 1,),
                                    SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                  ],
                                )
                              ],
                            ),)
                          ],
                        ), onTap: () {
                          setState(() {
                            info.themeColorIndex = 1;
                          });
                        },),
                      ),

                      Spacer(flex: 1,),
                      Container(
                        width: 48,
                        height: 48,
                        child: GestureDetector(child: Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Color(0xFFCBDBFF),
                                  borderRadius: BorderRadius.circular(48)
                              ),
                            ),
                            Visibility(visible: info.themeColorIndex == 2,child: Column(
                              children: [
                                Spacer(flex: 1,),
                                Row(
                                  children: [
                                    Spacer(flex: 1,),
                                    SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                  ],
                                )
                              ],
                            ),)
                          ],
                        ), onTap: () {
                          setState(() {
                            info.themeColorIndex = 2;
                          });
                        },),
                      ),

                      Spacer(flex: 1,),

                      Container(
                        width: 48,
                        height: 48,
                        child: GestureDetector(child: Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFD8D8),
                                  borderRadius: BorderRadius.circular(48)
                              ),
                            ),
                            Visibility(visible: info.themeColorIndex == 3,child: Column(
                              children: [
                                Spacer(flex: 1,),
                                Row(
                                  children: [
                                    Spacer(flex: 1,),
                                    SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                  ],
                                )
                              ],
                            ),)
                          ],
                        ), onTap: () {
                          setState(() {
                            info.themeColorIndex = 3;
                          });
                        },),
                      ),

                      SizedBox(width: 32,),
                    ]
                ),


                SizedBox(height: 22,),

                Row(
                  children: [
                    SizedBox(width: 20,),
                    SizedBox(width: 16, height: 16, child: buildImage('${pageTag}music')),
                    SizedBox(width: 8,),
                    buildText('Background Music', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                    Spacer(flex: 1,)
                  ],
                ),

                SizedBox(height: 12,),

                Row(
                  children: [
                    const SizedBox(width: 32,),
                    GestureDetector(child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              child: ClipOval(child: buildImage('${PAGE_ADD}/not_have'),),
                            ),
                            Visibility(visible: info.backgroundMusicIndex == 0,child: Container(
                              width: 48,
                              height: 48,
                              child: Column(
                                children: [
                                  Spacer(flex: 1,),
                                  Row(
                                    children: [
                                      Spacer(flex: 1,),
                                      SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                    ],
                                  )
                                ],
                              ),
                            ),)
                          ],
                        ),
                        SizedBox(height: 12,),
                        buildText('Not have', Color(info.backgroundMusicIndex == 0? 0xFF1EC691 : 0xFFCACAD1), 12)
                      ],
                    ), onTap: () {
                      setState(() {
                        info.backgroundMusicIndex = 0;
                      });
                    },),

                    Spacer(flex: 1,),
                    Container(
                      child:  GestureDetector(child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                child: ClipOval(child: buildImage('${PAGE_MAIN_TAB}/mode_background1'),),
                              ),
                              Visibility(visible: info.backgroundMusicIndex == 1,child: Container(
                                width: 48,
                                height: 48,
                                child: Column(
                                  children: [
                                    Spacer(flex: 1,),
                                    Row(
                                      children: [
                                        Spacer(flex: 1,),
                                        SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                      ],
                                    )
                                  ],
                                ),
                              ),)
                            ],
                          ),
                          SizedBox(height: 12,),
                          buildText('pitter-patter', Color(info.backgroundMusicIndex == 1? 0xFF1EC691 : 0xFFCACAD1), 12)
                        ],
                      ), onTap: () {
                        setState(() {
                          info.backgroundMusicIndex = 1;
                        });
                      },),
                    ),

                    Spacer(flex: 1,),
                    Container(
                      child:     GestureDetector(child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                child: ClipOval(child: buildImage('${PAGE_MAIN_TAB}/mode_background2'),),
                              ),
                              Visibility(visible: info.backgroundMusicIndex == 2,child: Container(
                                width: 48,
                                height: 48,
                                child: Column(
                                  children: [
                                    Spacer(flex: 1,),
                                    Row(
                                      children: [
                                        Spacer(flex: 1,),
                                        SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                      ],
                                    )
                                  ],
                                ),
                              ),)
                            ],
                          ),
                          SizedBox(height: 12,),
                          buildText('stream', Color(info.backgroundMusicIndex == 2? 0xFF1EC691 : 0xFFCACAD1), 12)
                        ],
                      ), onTap: () {
                        setState(() {
                          info.backgroundMusicIndex = 2;
                        });
                      },),
                    ),


                    Spacer(flex: 1,),
                    Container(
                      child:  GestureDetector(child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(48)
                                ),
                                child: ClipOval(child: buildImage('${PAGE_MAIN_TAB}/mode_background3')),
                              ),
                              Visibility(visible: info.backgroundMusicIndex == 3,child: Container(
                                width: 48,
                                height: 48,
                                child: Column(
                                  children: [
                                    Spacer(flex: 1,),
                                    Row(
                                      children: [
                                        Spacer(flex: 1,),
                                        SizedBox(width: 24, height: 24, child: buildImage('${pageTag}check'),)
                                      ],
                                    )
                                  ],
                                ),
                              ),)
                            ],
                          ),
                          SizedBox(height: 12,),
                          buildText('light music', Color(info.backgroundMusicIndex == 3? 0xFF1EC691 : 0xFFCACAD1), 12)
                        ],
                      ), onTap: () {
                        setState(() {
                          info.backgroundMusicIndex = 3;
                        });
                      },),
                    ),


                    SizedBox(width: 32,),
                  ],
                ),

                SizedBox(height: 24,),
                // Row(
                //   children: [
                //     SizedBox(width: 20,),
                //     buildText('End Reminder', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold, maxLines: 5),
                //     Spacer(flex: 1,),
                //     Stack(
                //       children: [
                //         Container(
                //           width: 50,
                //           height: 24,
                //           child: GestureDetector(
                //             child: Visibility(visible: info.endRemind,child: Stack(
                //               children: [
                //                 SizedBox(width: 50, height: 24, child: buildImage('${PAGE_ADD}/select_able'),),
                //                 Column(
                //                   children: [
                //                     Spacer(flex: 1,),
                //                     Row(
                //                       children: [
                //                         Spacer(flex: 1,),
                //                         SizedBox(width: 19, height: 19, child: buildImage('${PAGE_ADD}/white_round')),
                //                         SizedBox(width: 3,)
                //                       ],
                //                     ),
                //                     Spacer(flex: 1,),
                //                   ],
                //                 )
                //               ],
                //             ),),
                //             onTap: () {
                //               setState(() {
                //                 info.endRemind = !info.endRemind;
                //               });
                //             },
                //           ),
                //         ),
                //         Container(
                //           width: 50,
                //           height: 24,
                //           child: GestureDetector(
                //             child: Visibility(visible: !info.endRemind,child: Stack(
                //               children: [
                //                 SizedBox(width: 50, height: 24, child: buildImage('${PAGE_ADD}/select_unable'),),
                //                 Column(
                //                   children: [
                //                     Spacer(flex: 1,),
                //                     Row(
                //                       children: [
                //                         SizedBox(width: 3,),
                //                         SizedBox(width: 19, height: 19, child: buildImage('${PAGE_ADD}/white_round')),
                //                         Spacer(flex: 1,),
                //                         SizedBox(width: 13, height: 9, child: buildImage('${PAGE_ADD}/next_arrow'),),
                //                         SizedBox(width: 9,)
                //                       ],
                //                     ),
                //                     Spacer(flex: 1,),
                //                   ],
                //                 )
                //               ],
                //             ),),
                //             onTap: () {
                //               setState(() {
                //                 info.endRemind = !info.endRemind;
                //               });
                //             },
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(width: 20,),
                //   ],
                // ),
                //
                //
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20, top: 17),
                //   child: buildText('Take control of your time in advance, and end your focus more smoothly.',
                //       Color(0xFFCACAD1), 12, textAlign: TextAlign.start, maxLines: 4),
                // ),


                GestureDetector(
                  child: Container(
                    height: 52,
                    width: screenWidth(context),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                    decoration: BoxDecoration(
                        color: Color(0xFF5099B5),
                        borderRadius: BorderRadius.circular(75)
                    ),
                    child: Center(
                      child: buildText('Save', Colors.white, 16),
                    ),
                  ),
                  onTap: () {
                    if(info.name.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please enter a focus name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }
                    if(!mounted) return;
                    setState(() {
                      info.sys = DateTime.now().millisecondsSinceEpoch;
                      info.date = DateFormat('yyyy-MM-dd').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              info.sys));
                      fetchAndAddFocusModeInfo(info);
                    });
                    back();
                  },
                ),

                SizedBox(height: 20,)
              ],
            ),
          ))

        ],
      ),
    )
        ,
        onWillPop: () async {
          back();
          return false;
        });
  }


  Future<void> fetchAndAddFocusModeInfo(FocusModeInfo m) async {
    List<FocusModeInfo> list = await InfoStore.hqCreatedMode();
    bool haveSame = false;
    if(list.isNotEmpty) {
      list.forEach((mode) {
        if(mode.name == m.name) {
          haveSame = true;
        }
      });
    }
    if(haveSame) return;
    list.add(m);
    InfoStore.bcCreatedMode(list);
  }

}