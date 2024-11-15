import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen_bleat/bleat_info1/FocusInfo.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:listen_bleat/info_store1/InfoStore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bleat_info1/FavoriteMode.dart';
import '../bleat_info1/FocusStatisticsInfo.dart';
import '../component/Image.dart';
import '../component/Text.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  String pageTag = '${PAGE_MAIN_TAB}/';
  int _selectedIndex = 0;

  // int focus = 0; //今日专注次数
  // int focusTime = 0; //今日完成专注时间之和
  // int failure = 0; //今日失败次数
  // int focusModeSize = 0; //专注模式列表的大小
  List<FocusInfo> focusInfoList = []; //关注历史记录
  FocusInfo? todayFocusInfo; //今日关注历史记录

  FocusStatisticsInfo statisticsInfo = FocusStatisticsInfo();

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    // 创建日期格式化器
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // 打印前 7 天的日期
    for (int i = 1; i <= 7; i++) {
      DateTime previousDate = today.subtract(Duration(days: i));
      String formattedDate = dateFormat.format(previousDate);
      StatisticsLastDay lastDay = StatisticsLastDay();
      lastDay.date = formattedDate;
      statisticsInfo.list.add(lastDay);
    }

    fetchFocusRecordInfo();
    fetchStatisticsInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    fetchFocusRecordInfo();
    fetchStatisticsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: screenWidth(context),
              height: screenHeight(context),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFB),
              ),
              child: buildImage('${pageTag}bg'),
            ),
            Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: Color(0xFF5099B5),
                  // 选中时的颜色
                  unselectedItemColor: Color(0XFFD5D5DB),
                  // 未选中时的颜色
                  onTap: _onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                        icon: SizedBox(
                          width: 24,
                          height: 24,
                          child: buildImage(_selectedIndex == 0
                              ? '${pageTag}home'
                              : '${pageTag}home_unable'),
                        ),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: SizedBox(
                            width: 24,
                            height: 24,
                            child: buildImage(_selectedIndex == 1
                                ? '${pageTag}statistics'
                                : '${pageTag}statistics_unable')),
                        label: 'Statistics'),
                    BottomNavigationBarItem(
                        icon: SizedBox(
                            width: 24,
                            height: 24,
                            child: buildImage(_selectedIndex == 2
                                ? '${pageTag}settings'
                                : '${pageTag}settings_unable')),
                        label: 'Settings')
                  ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: Visibility(child: FloatingActionButton(
                backgroundColor: Color(0xFF5099B5),
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, PAGE_ADD);
                },
                child: ClipOval(
                  child: Container(
                    color: Color(0xFF5099B5),
                    width: 64,
                    height: 64,
                    child: buildImage('${pageTag}add', fit: BoxFit.fill),
                  ),
                ),
              ), visible: _selectedIndex == 0,),
              body: buildPage(_selectedIndex),
            ),
          ],
        ),
        onWillPop: () async {
          return false;
        });
  }

  Widget buildPage(int index) {
    if (index == 0) {
      return buildHome();
    } else if (index == 1) {
      return buildStatistics();
    } else {
      return buildSetting();
    }
  }

  Widget buildHome() {
    return Container(
      width: screenWidth(context),
      padding: EdgeInsets.only(left: 28, top: 60, right: 28),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 163,
                child: buildImage('${pageTag}morning', fit: BoxFit.scaleDown),
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 92,
                decoration: BoxDecoration(
                    color: Color(0x33FEC38A),
                    borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      buildText("Today's Focus", Color(0xFF525252), 12),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          buildText(
                              todayFocusInfo == null
                                  ? '0'
                                  : todayFocusInfo!.focusSuccessNumber
                                      .toString(),
                              Color(0xFFFFB268),
                              20,
                              fontWeight: FontWeight.bold),
                          const SizedBox(
                            width: 4,
                          ),
                          buildText(
                              todayFocusInfo == null
                                  ? '(0mins)'
                                  : '(${secondsToOtherTimeStringNoFH(todayFocusInfo!.focusSuccessTime)})',
                              Color(0xFFC3C3C3),
                              14,
                              fontWeight: FontWeight.bold),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(
                width: 19,
              ),
              Expanded(
                  child: Container(
                height: 92,
                decoration: BoxDecoration(
                    color: Color(0xFFDCEBF1),
                    borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: Column(
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      buildText("Today's Failure", Color(0xFF525252), 12),
                      const SizedBox(
                        height: 8,
                      ),
                      buildText(
                          todayFocusInfo == null
                              ? '0'
                              : todayFocusInfo!.focusFailureNumber.toString(),
                          Color(0xFF339FC8),
                          20,
                          fontWeight: FontWeight.bold),
                      Spacer(
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
          Expanded(child: buildList())
        ],
      ),
    );
  }

  Widget buildStatistics() {
    return Container(
      padding: EdgeInsets.only(left: 28, top: 60, right: 28),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 108,
                child: buildImage('${pageTag}statistics_title',
                    fit: BoxFit.scaleDown),
              ),
              Spacer(flex: 1,)
            ],
          ),


          Container(
              height: 306,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFF1F1F1), // 边框颜色
                  width: 1, // 边框宽度
                ),
                borderRadius: BorderRadius.circular(16), // 圆角边框
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      buildText('Last ${statisticsInfo.list.length} days', Color(0xFF7C828A), 16),
                      Spacer(flex: 1,)
                    ],
                  ),
                  Expanded(child: buildStatisticsList())
                ],
              )
          ),
          Expanded(child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          height: 92,
                          decoration: BoxDecoration(
                              color: Color(0x33FEC38A),
                              borderRadius: BorderRadius.circular(24)),
                          child: Center(
                            child: Column(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                buildText("Total's Focus", Color(0xFF525252), 12),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    buildText(
                                        statisticsInfo.totalFocusSuccessNumber.toString(),
                                        Color(0xFFFFB268),
                                        20,
                                        fontWeight: FontWeight.bold),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    buildText(
                                        '(${secondsToOtherTimeStringNoFH(statisticsInfo.totalFocusSuccessTime)})',
                                        Color(0xFFC3C3C3),
                                        14,
                                        fontWeight: FontWeight.bold),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 19,
                    ),
                    Expanded(
                        child: Container(
                          height: 92,
                          decoration: BoxDecoration(
                              color: Color(0xFFDCEBF1),
                              borderRadius: BorderRadius.circular(24)),
                          child: Center(
                            child: Column(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                buildText("Total's Failure", Color(0xFF525252), 12),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                    buildText(
                                        statisticsInfo.totalFocusFailureNumber.toString(),
                                        Color(0xFF339FC8),
                                        20,
                                        fontWeight: FontWeight.bold),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    buildText(
                                        '(${secondsToOtherTimeStringNoFH(statisticsInfo.totalFocusFailureTime)})',
                                        Color(0xFFC3C3C3),
                                        14,
                                        fontWeight: FontWeight.bold),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),

                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),

                Container(
                  width: screenWidth(context),
                  height: 74,
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF1F1F1), // 边框颜色
                      width: 1, // 边框宽度
                    ),
                    borderRadius: BorderRadius.circular(16), // 圆角边框
                  ),
                  child:  Row(
                    children: [
                      SizedBox(width: 10,),
                      Expanded(child: Column(
                        children: [
                          Spacer(flex: 1,),
                          buildText("Today's Focus", Color(0xFF525252), 12),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Spacer(flex: 1,),
                              buildText(
                                  statisticsInfo.todayFocusSuccessNumber.toString(),
                                  Color(0xFF2C2B49),
                                  20,
                                  fontWeight: FontWeight.bold),
                              SizedBox(width: 4,),
                              buildText(
                                  '(${secondsToOtherTimeStringNoFH(statisticsInfo.todayFocusSuccessTime)})',
                                  Color(0xFFC3C3C3),
                                  14,
                                  fontWeight: FontWeight.bold),
                              Spacer(flex: 1,),
                            ],
                          ),
                          Spacer(flex: 1,),
                        ],
                      )),

                      Spacer(flex: 1,),


                      Expanded(child: Column(
                        children: [
                          Spacer(flex: 1,),
                          buildText("Today's Failure", Color(0xFF525252), 12),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Spacer(
                                flex: 1,
                              ),
                              buildText(
                                  statisticsInfo.todayFocusSuccessNumber.toString(),
                                  Color(0xFF2C2B49),
                                  20,
                                  fontWeight: FontWeight.bold),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                          Spacer(flex: 1,),

                        ],
                      )),

                      SizedBox(width: 10,),
                    ],
                  ),
                ),

                Container(
                  width: screenWidth(context),
                  height: 74,
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF1F1F1), // 边框颜色
                      width: 1, // 边框宽度
                    ),
                    borderRadius: BorderRadius.circular(16), // 圆角边框
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Expanded(child: Column(
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            buildText("Favorite Plans", Color(0xFF525252), 12),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                buildText(
                                    statisticsInfo.favoriteModeName.isEmpty? 'none' : statisticsInfo.favoriteModeName,
                                    Color(0xFF2C2B49),
                                    20,
                                    fontWeight: FontWeight.bold),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        )),

                        Spacer(flex: 1,),


                        Expanded(child: Column(
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            buildText("Focus Count", Color(0xFF525252), 12),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                buildText(
                                    statisticsInfo.favoriteFocusSuccessNumber.toString(),
                                    Color(0xFF2C2B49),
                                    20,
                                    fontWeight: FontWeight.bold),
                                const SizedBox(
                                  width: 4,
                                ),
                                buildText(
                                    '(${secondsToOtherTimeStringNoFH(statisticsInfo.favoriteFocusSuccessTime)})',
                                    Color(0xFFC3C3C3),
                                    14,
                                    fontWeight: FontWeight.bold),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            ),
                          ],
                        )),

                        SizedBox(width: 10,),
                      ],
                    ),
                  ),
                ),


                GestureDetector(
                  child: Container(
                    width: screenWidth(context),
                    margin: EdgeInsets.only(top: 16),
                    height: 74,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: screenWidth(context),
                          height: 74,
                          child: buildImage('${pageTag}statistics_focus_history', fit: BoxFit.fill),
                        ),

                        Column(
                          children: [
                            Spacer(flex: 1,),
                            Row(
                              children: [
                                Spacer(flex: 1,),

                                buildText('Focus History>', Colors.white, 14),
                                SizedBox(width: 24,)
                              ],
                            ),
                            Spacer(flex: 1,),
                          ],
                        )

                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, PAGE_HISTORY);
                  },
                ),
                SizedBox(height: 116,)
              ],
            )
          ))

        ],
      ),
    );
  }

  Widget buildStatisticsList() {
    return ListView.builder(
        itemCount: statisticsInfo.list.length,
        itemBuilder: (BuildContext context, int index) {
          StatisticsLastDay last = statisticsInfo.list[index];
          return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                buildText(last.date, Color(0xFF7C828A), 12),
                SizedBox(width: 14,),
                Expanded(child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                      color: const Color(0XFF147AD6),
                      backgroundColor: const Color(0X33848484),
                      borderRadius: BorderRadius.circular(4),
                      value: last.progress),
                )),
                SizedBox(width: 12,),
                SizedBox(width: 60, child: buildText(secondsToOtherTimeStringNoFH(last.totalTime), Color(0xFF7C828A), 12),)
              ],
            ),
          );

        });
  }

  Widget buildList() {
    return FutureBuilder<List<FocusModeInfo>>(
      future: fetchFocusModeInfo(), // 传入 Future
      builder:
          (BuildContext context, AsyncSnapshot<List<FocusModeInfo>> snapshot) {
        // 根据 snapshot 的状态构建不同的 UI
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildEmpty(); // 加载中
        } else if (snapshot.hasError) {
          return buildEmpty(); // 错误处理
        } else {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return buildEmpty();
          } else {
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    FocusModeInfo info = snapshot.data![index];
                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: screenWidth(context),
                        height: 190,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SizedBox(
                              width: screenWidth(context),
                              height: screenHeight(context),
                              child: buildImage(fetchBackgroundMusicBg(
                                  info.backgroundMusicIndex)),
                            ),
                            SizedBox(
                              width: screenWidth(context),
                              height: screenHeight(context),
                              child: buildImage(
                                  fetchThemeMask(info.themeColorIndex)),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    if (focusInfoList.isNotEmpty &&
                                        focusInfoList[0].modes!.isNotEmpty &&
                                        focusInfoList[0].modes![0].mode !=
                                            null &&
                                        focusInfoList[0].modes![0].mode!.name ==
                                            info.name)
                                      SizedBox(
                                        width: 107,
                                        height: 29,
                                        child: Stack(
                                          children: [
                                            buildImage('${pageTag}last_used'),
                                            Center(
                                              child: buildText('Last Used',
                                                  Color(0xFFFFF7F7), 14),
                                            )
                                          ],
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        height: 29,
                                      )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Expanded(child: buildText(info.name, Color(0xFFFFFFFF), 31,
                                        fontWeight: FontWeight.bold)),
                                    Spacer(
                                      flex: 1,
                                    )
                                  ],
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 31,
                                      padding:
                                          EdgeInsets.only(left: 12, right: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(33)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                            height: 12,
                                            child:
                                                buildImage('${pageTag}write'),
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: buildText(
                                                  '${info.focusTime} Mins',
                                                  Color(0xFF2C2B49),
                                                  14)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 31,
                                      padding:
                                          EdgeInsets.only(left: 12, right: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(33)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 15,
                                              height: 12,
                                              child:
                                                  buildImage('${pageTag}eat')),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                              child: buildText(
                                                  '${info.breakTime} Mins',
                                                  Color(0xFF2C2B49),
                                                  14)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, PAGE_FOCUS_DETAIL,
                            arguments: info);
                      },
                    );
                  }),
            );
          } // 显示结果
        }
      },
    );
  }

  Widget buildEmpty() {
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        SizedBox(
            width: 138, height: 138, child: buildImage('${pageTag}home_empty')),
        SizedBox(
          height: 20,
        ),
        buildText('No records yet', Color(0xFFC3C3C3), 12),
        Spacer(
          flex: 1,
        )
      ],
    );
  }

  //获取关注记录信息
  Future<void> fetchFocusRecordInfo() async {
    List<FocusInfo> list = await InfoStore.hqFocusRecord();
    String date = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));
    if (list.isEmpty) {
      setState(() {
        focusInfoList.clear();
        todayFocusInfo = null;
      });
    } else {
      setState(() {
        focusInfoList.clear();
        list.forEach((element) {
          focusInfoList.add(element);
          if (element.date == date) {
            todayFocusInfo = element;
          }
        });
      });
    }
  }

  Future<List<FocusModeInfo>> fetchFocusModeInfo() async {
    List<FocusModeInfo> list = await InfoStore.hqCreatedMode();
    return list;
  }

  Future<void> fetchStatisticsInfo() async {
    List<FocusInfo> list = await InfoStore.hqFocusRecord();
    FocusStatisticsInfo info = FocusStatisticsInfo();
    DateTime today = DateTime.now();

    // 创建日期格式化器
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // 打印前 7 天的日期
    for (int i = 1; i <= 7; i++) {
      DateTime previousDate = today.subtract(Duration(days: i));
      String formattedDate = dateFormat.format(previousDate);
      StatisticsLastDay lastDay = StatisticsLastDay();
      lastDay.date = formattedDate;
      info.list.add(lastDay);
    }

    int totalFocusSuccessNumber = 0;
    int totalFocusFailureNumber = 0;
    int totalFocusSuccessTime = 0;
    int totalFocusFailureTime = 0;

    int todayFocusSuccessNumber = 0;
    int todayFocusFailureNumber = 0;
    int todayFocusSuccessTime = 0;
    int todayFocusFailureTime = 0;

    FavoriteMode baseFavoriteMode = FavoriteMode();

    Map<String, FavoriteMode> map = Map();

    String date = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch));

    if (list.isNotEmpty) {
      list.forEach((focusInfo) {
        totalFocusSuccessNumber += focusInfo.focusSuccessNumber;
        totalFocusFailureNumber += focusInfo.focusFailureNumber;
        totalFocusSuccessTime += focusInfo.focusSuccessTime;
        totalFocusFailureTime += focusInfo.focusFailureTime;

        if (focusInfo.modes != null && focusInfo.modes!.isNotEmpty) {
          focusInfo.modes!.forEach((record) {
            if (record.mode != null) {
              if (map.containsKey(record.mode!.name) &&
                  map[record.mode!.name] != null) {
                FavoriteMode fav = map[record.mode!.name]!;
                fav.focusTime += record.focusSuccessTime;
                if (record.focusSuccess) {
                  fav.focusNumber += 1;
                }
                map[record.mode!.name] = fav;
              } else {
                FavoriteMode fav = FavoriteMode();
                fav.name = record.mode!.name;
                fav.focusTime += record.focusSuccessTime;
                if (record.focusSuccess) {
                  fav.focusNumber += 1;
                }
                map[record.mode!.name] = fav;
              }
            }
          });
        }

        if (date == focusInfo.date) {
          todayFocusSuccessNumber += focusInfo.focusSuccessNumber;
          todayFocusFailureNumber += focusInfo.focusFailureNumber;
          todayFocusSuccessTime += focusInfo.focusSuccessTime;
          todayFocusFailureTime += focusInfo.focusFailureTime;
        }
        info.list.forEach((item) {
          if (item.date == focusInfo.date) {
            item.totalTime = focusInfo.focusSuccessTime;
            item.progress = focusInfo.focusSuccessTime / (8 * 60 * 60);
            print('progress-----${item.progress}---${focusInfo.focusSuccessTime}----');
          }
        });
      });

      if (map.isNotEmpty) {
        map.forEach((name, favoriteMode) {
          if (favoriteMode.focusNumber > baseFavoriteMode.focusNumber) {
            baseFavoriteMode = favoriteMode;
          }
        });
      }
    }

    info.favoriteModeName = baseFavoriteMode.name;
    info.favoriteFocusSuccessNumber = baseFavoriteMode.focusNumber;
    info.favoriteFocusSuccessTime = baseFavoriteMode.focusTime;

    info.totalFocusSuccessNumber = totalFocusSuccessNumber;
    info.totalFocusFailureNumber = totalFocusFailureNumber;
    info.totalFocusSuccessTime = totalFocusSuccessTime;
    info.totalFocusFailureTime = totalFocusFailureTime;
    info.todayFocusSuccessNumber = todayFocusSuccessNumber;
    info.todayFocusFailureNumber = todayFocusFailureNumber;
    info.todayFocusSuccessTime = todayFocusSuccessTime;
    info.todayFocusFailureTime = todayFocusFailureTime;

    setState(() {
      statisticsInfo = info;
    });
  }

  Widget buildSetting() {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 60, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 97,
                child: buildImage('${pageTag}setting_title',
                    fit: BoxFit.scaleDown),
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            child: Container(
              width: screenWidth(context),
              height: 70,
              padding: EdgeInsets.only(left: 20, right: 8),
              decoration: BoxDecoration(
                  color: Color(0xFFEFFAFD),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: buildImage('${pageTag}setting_icon'),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  buildText('Share with Friends', Color(0xFF333333), 15),
                  Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: buildImage('${pageTag}next'),
                  )
                ],
              ),
            ),
            onTap: () {
              toShare();
            },
          ),
          SizedBox(height: 20),
          GestureDetector(
            child: Container(
              width: screenWidth(context),
              height: 70,
              padding: EdgeInsets.only(left: 20, right: 8),
              decoration: BoxDecoration(
                  color: Color(0xFFEFFAFD),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: buildImage('${pageTag}setting_icon'),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  buildText('Privacy Policy', Color(0xFF333333), 15),
                  Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: buildImage('${pageTag}next'),
                  )
                ],
              ),
            ),
            onTap: () {
              toPolicy();
            },
          ),
          SizedBox(height: 20),
          Visibility(
            visible: Platform.isIOS,
            child: GestureDetector(
              child: Container(
                width: screenWidth(context),
                height: 70,
                padding: EdgeInsets.only(left: 20, right: 8),
                decoration: BoxDecoration(
                    color: Color(0xFFEFFAFD),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: buildImage('${pageTag}setting_icon'),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    buildText('Terms of Service', Color(0xFF333333), 15),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: buildImage('${pageTag}next'),
                    )
                  ],
                ),
              ),
              onTap: () {
                toTerms();
              },
            ),
          )
        ],
      ),
    );
  }

  static Future<void> toShare() async {
    String package = Platform.isAndroid ? '' : '';
    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$package'
        : 'https://apps.apple.com/app/id$package';
    Share.share(url);
  }

  Future<void> toPolicy() async {
    String host = 'stayfoolish.feishu.cn';
    String path = '/docx';
    final Uri uri = Uri(scheme: 'https', host: host, path: path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> toTerms() async {
    String host = 'stayfoolish.feishu.cn';
    String path = '/docx';
    final Uri uri = Uri(scheme: 'https', host: host, path: path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
