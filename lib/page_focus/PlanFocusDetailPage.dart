import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:listen_bleat/component/Image.dart';
import 'package:listen_bleat/info_store1/InfoStore.dart';

import '../bleat_info1/FocusAndModeRecord.dart';
import '../bleat_info1/FocusInfo.dart';
import '../component/Text.dart';

class PlanFocusDetailPage extends StatefulWidget {
  PlanFocusDetailPage({super.key, required this.mode});

  FocusModeInfo mode;

  @override
  State<PlanFocusDetailPage> createState() => _PlanFocusDetailPageState();
}

class _PlanFocusDetailPageState extends State<PlanFocusDetailPage> {
  String pageTag = '${PAGE_FOCUS_DETAIL}/';
  int pageFocusStatus = 0;//0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
  int focusShowTime = 0;
  int breakShowTime = 0;
  bool longPressWaiting = false;
  Timer? countdownTimer;
  Timer? longPress3STimer;
  Timer? breakCountdownTimer;
  int themeColorIndex = 0;
  int backgroundMusicIndex = 0;

  AudioPlayer player = AudioPlayer();
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  String dataSource = '';


  @override
  void initState() {
    super.initState();
    setState(() {
      focusShowTime = widget.mode.focusTime * 60;
      breakShowTime = widget.mode.breakTime * 60;
      themeColorIndex = widget.mode.themeColorIndex;
      backgroundMusicIndex = widget.mode.backgroundMusicIndex;
    });

    player.setReleaseMode(ReleaseMode.stop);
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
        _duration = value;
      }),
    );
    player.getCurrentPosition().then(
          (value) => setState(() {
        _position = value;
      }),
    );
    _initStreams();
    startFocus(true);
    playMusic();
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    longPress3STimer?.cancel();
    breakCountdownTimer?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  void playMusic() async {
    if(_isPlaying) {
      _stop();
    }
    player.setReleaseMode(ReleaseMode.loop);
    await player.setSource(AssetSource(fetchBackgroundMusic(backgroundMusicIndex)));
    await _play();
  }

  void back() {
    //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
    if(pageFocusStatus == 0) return;
    _stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                  width: screenWidth(context),
                  height: screenHeight(context),
                  child: buildImage(fetchPageBackground(themeColorIndex))
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Visibility(visible: pageFocusStatus == 1 || pageFocusStatus == 2 || pageFocusStatus == 4,child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: buildImage('${PAGE_ADD}/back'),
                          ),
                        ),
                        onTap: () {
                          back();
                        },
                      ),),

                      Visibility(child: SizedBox(width: 72, height: 68), visible: pageFocusStatus == 0 || pageFocusStatus == 3,),

                      //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成

                      buildText('Detail', Color(0xFF2C2B49), 18, fontWeight: FontWeight.bold),

                      Spacer(flex: 1,),

                      Visibility(visible: pageFocusStatus == 0,child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 10, top: 12, bottom: 12),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: buildImage('${pageTag}theme_top'),
                          ),
                        ),
                        onTap: () {
                          showThemeDialog(widget.mode.themeColorIndex, (i) {
                            setState(() {
                              themeColorIndex = i;
                            });
                          });
                        },
                      ),),


                      Visibility(visible: pageFocusStatus == 0 || pageFocusStatus == 3,child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 20, top: 12, bottom: 12),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: buildImage('${pageTag}music_top'),
                          ),
                        ),
                        onTap: () {
                          showMusicDialog(backgroundMusicIndex, (i) {
                            setState(() {
                              backgroundMusicIndex = i;
                            });
                            playMusic();
                          });
                        },
                      ),)
                    ],
                  ),
                  SizedBox(height: 60,),

                  Expanded(child: Stack(
                    children: [
                      if(pageFocusStatus == 0) //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
                        Visibility(child: GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 190,
                                height: 240,
                                child: buildImage('${pageTag}focus_ing'),
                              ),
                              SizedBox(height: 20,),
                              buildText('${timeInt2String(focusShowTime)}', Color(0xFF2C2B49), 26, fontWeight: FontWeight.bold),
                              Spacer(flex: 1,),
                              buildText('Long press to exit', Color(0xFFCACAD1), 12),
                              SizedBox(height: 16,),
                              Visibility(visible: longPressWaiting,child: Container(
                                margin: const EdgeInsets.only(left: 30, right: 30),
                                child: SizedBox(
                                  height: 6,
                                  child: LinearProgressIndicator(
                                      color: const Color(0xFF5099B4),
                                      backgroundColor: const Color(0x24504D4D),
                                      borderRadius: BorderRadius.circular(3),
                                      value: null),
                                ),
                              ),),
                              SizedBox(height: 54,)
                            ],
                          ),
                        )),


                      if(pageFocusStatus == 1) //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
                        Visibility(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 190,
                              height: 240,
                              child: buildImage('${pageTag}focus_finished'),
                            ),
                            SizedBox(height: 20,),
                            buildText('${timeInt2String(widget.mode.focusTime * 60)}', Color(0xFF2C2B49), 26, fontWeight: FontWeight.bold),
                            SizedBox(height: 28,),
                            SizedBox(width: 330, child: buildText(
                                'You just completed a focus session of ${secondsToOtherTimeStringNoFH(widget.mode.focusTime * 60)}; your efforts were not in vain—give yourself a pat on the back!',
                                Color(0xFFCACAD1), 12, maxLines: 4)),
                            SizedBox(height: 64,),
                            GestureDetector(
                              child: Container(
                                height: 52,
                                width: 272,
                                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                                decoration: BoxDecoration(
                                    color: Color(0xFF5099B5),
                                    borderRadius: BorderRadius.circular(75)
                                ),
                                child: Center(
                                  child: buildText('Take a Break', Colors.white, 16),
                                ),
                              ),
                              onTap: () {
                                startBreak();
                              },
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              child: Container(
                                width: 272,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    buildText('Skip', Color(0xFF5B8FCF), 15),
                                    Container(
                                      color: Color(0xFF5B8FCF),
                                      width: 40,
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                startFocus(true);
                              },
                            ),
                            SizedBox(height: 54,)
                          ],
                        )),


                      if(pageFocusStatus == 2) //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
                        Visibility(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 190,
                              height: 240,
                              child: buildImage('${pageTag}focus_not_finished'),
                            ),
                            SizedBox(height: 20,),
                            buildText('${timeInt2String(focusShowTime)}', Color(0xFF2C2B49), 26, fontWeight: FontWeight.bold),
                            SizedBox(height: 28,),
                            SizedBox(width: 330, child: buildText(
                                'This focus session was not completed, but failure is part of success. Keep going!', Color(0xFFCACAD1), 12, maxLines: 4),),
                            SizedBox(height: 64,),
                            GestureDetector(
                              child: Container(
                                height: 52,
                                width: 272,
                                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                                decoration: BoxDecoration(
                                    color: Color(0xFF5099B5),
                                    borderRadius: BorderRadius.circular(75)
                                ),
                                child: Center(
                                  child: buildText('Restart', Colors.white, 16),
                                ),
                              ),
                              onTap: () {
                                startFocus(true);
                              },
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              child: Container(
                                width: 272,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    buildText('Exit', Color(0xFF5B8FCF), 15),
                                    Container(
                                      color: Color(0xFF5B8FCF),
                                      width: 40,
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                back();
                              },
                            ),
                            SizedBox(height: 54,)
                          ],
                        )),


                      if(pageFocusStatus == 3) //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
                        Visibility(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 190,
                              height: 240,
                              child: buildImage('${pageTag}break'),
                            ),
                            SizedBox(height: 20,),
                            buildText('${timeInt2String(breakShowTime)}', Color(0xFF2C2B49), 26, fontWeight: FontWeight.bold),
                            SizedBox(height: 28,),
                            SizedBox(width: 330, child: buildText("You’ve worked hard \nnow take a good rest and recharge!", Color(0xFFCACAD1), 12, maxLines: 4),),
                            SizedBox(height: 64,),
                            GestureDetector(
                              child: Container(
                                height: 52,
                                width: 272,
                                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                                decoration: BoxDecoration(
                                    color: Color(0xFF5099B5),
                                    borderRadius: BorderRadius.circular(75)
                                ),
                                child: Center(
                                  child: buildText('End Early', Colors.white, 16),
                                ),
                              ),
                              onTap: () {
                                cancelBreak();
                              },
                            ),
                            SizedBox(height: 110,),
                          ],
                        )),


                      if(pageFocusStatus == 4) //0-专注页面，1-专注成功页，2-专注失败页，3-休息页面，4-休息完成
                        Visibility(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 190,
                              height: 240,
                              child: buildImage('${pageTag}break_finished'),
                            ),
                            SizedBox(height: 20,),
                            buildText('${timeInt2String(widget.mode.breakTime * 60)}', Color(0xFF2C2B49), 26, fontWeight: FontWeight.bold),
                            SizedBox(height: 28,),
                            SizedBox(width: 330, child: buildText(
                                'Break time is over. Feeling refreshed? Let’s continue to the next challenge!', Color(0xFFCACAD1), 12, maxLines: 4),),
                            SizedBox(height: 64,),
                            GestureDetector(
                              child: Container(
                                height: 52,
                                width: 272,
                                margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                                decoration: BoxDecoration(
                                    color: Color(0xFF5099B5),
                                    borderRadius: BorderRadius.circular(75)
                                ),
                                child: Center(
                                  child: buildText('Start Focusing', Colors.white, 16),
                                ),
                              ),
                              onTap: () {
                                startFocus(true);
                              },
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              child: Container(
                                width: 272,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    buildText('Exit', Color(0xFF5B8FCF), 15),
                                    Container(
                                      color: Color(0xFF5B8FCF),
                                      width: 40,
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                back();
                              },
                            ),
                            SizedBox(height: 54,)
                          ],
                        )),
                    ],
                  ))


                ],
              )
            ],
          ),
          onLongPress: () {
            print('onLongPress ------');
            countdownTimer?.cancel();
            startLongPress3s();
          },
          onLongPressUp: () {
            print('onLongPressUp ------');
            cancelLongPress();
          },
        ),
        onWillPop: () async {
          back();
          return false;
        });
  }

  void startFocus(bool fromMax) {
    if(!mounted) return;
    if(fromMax) {
      focusShowTime = widget.mode.focusTime * 60;
    }
    playMusic();
    setState(() {
      pageFocusStatus = 0;
    });
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(focusShowTime == 0) {
        timer.cancel();
        _stop();
        addFocusRecord(true, widget.mode.focusTime * 60 - focusShowTime);
        setState(() {
          pageFocusStatus = 1;
        });
      } else {
        setState(() {
          focusShowTime -= 1;
        });
      }

    });
  }

  Future<void> addFocusRecord(bool successRecord, int time) async {
    List<FocusInfo> list = await InfoStore.hqFocusRecord();
    int sys = DateTime.now().millisecondsSinceEpoch;
    String date = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMillisecondsSinceEpoch(sys));
    if(list.isNotEmpty) {
      FocusInfo? todayInfo;
      list.forEach((focusInfo) {
        if(focusInfo.date == date) {
          todayInfo = focusInfo;
        }
      });

      FocusAndModeRecord record = FocusAndModeRecord();
      record.date = date;
      record.sys = sys;
      record.mode = widget.mode;

      if(todayInfo != null) {
        list.remove(todayInfo);
        if(successRecord) {
          todayInfo!.focusSuccessNumber += 1;
          todayInfo!.focusSuccessTime += time;

          record.focusSuccess = true;
          record.focusSuccessTime = time;
        } else {
          todayInfo!.focusFailureNumber += 1;
          todayInfo!.focusFailureTime += time;

          record.focusFailure = true;
          record.focusFailureTime = time;
        }

        if(todayInfo!.modes == null || todayInfo!.modes!.isEmpty) {
          todayInfo!.modes = [record];
        } else {
          todayInfo!.modes!.add(record);
        }
        list.add(todayInfo!);
        InfoStore.bcFocusRecord(list);
      } else {
        FocusInfo info = FocusInfo();
        info.date = date;
        info.sys = sys;
        FocusAndModeRecord record = FocusAndModeRecord();
        record.date = date;
        record.sys = sys;
        record.mode = widget.mode;

        if(successRecord) {
          info.focusSuccessNumber += 1;
          info.focusSuccessTime += time;

          record.focusSuccess = true;
          record.focusSuccessTime = time;

        } else {
          info.focusFailureNumber += 1;
          info.focusFailureTime += time;

          record.focusFailure = true;
          record.focusFailureTime = time;
        }
        info.modes = [record];

        list.add(info);
        InfoStore.bcFocusRecord(list);
      }
    } else {
      FocusInfo info = FocusInfo();
      info.date = date;
      info.sys = sys;
      FocusAndModeRecord record = FocusAndModeRecord();
      record.date = date;
      record.sys = sys;
      record.mode = widget.mode;

      if(successRecord) {
        info.focusSuccessNumber += 1;
        info.focusSuccessTime += time;

        record.focusSuccess = true;
        record.focusSuccessTime = time;

      } else {
        info.focusFailureNumber += 1;
        info.focusFailureTime += time;

        record.focusFailure = true;
        record.focusFailureTime = time;
      }
      info.modes = [record];

      list.add(info);
      InfoStore.bcFocusRecord(list);
    }
  }

  void startBreak() {
    if(!mounted) return;
    setState(() {
      pageFocusStatus = 3;
    });
    playMusic();
    breakCountdownTimer?.cancel();
    breakCountdownTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(breakShowTime == 0) {
        timer.cancel();
        _stop();
        setState(() {
          pageFocusStatus = 4;
        });
      } else {
        setState(() {
          breakShowTime -= 1;
        });
      }
    });
  }

  void cancelBreak() {
    breakCountdownTimer?.cancel();
    back();
  }

  void startLongPress3s() {
    if(!mounted || pageFocusStatus != 0) return;
    setState(() {
      longPressWaiting = true;
    });
    longPress3STimer?.cancel();
    longPress3STimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if(timer.tick >= 3) {
        timer.cancel();
        _stop();
        addFocusRecord(false, widget.mode.focusTime * 60 - focusShowTime);
        setState(() {
          longPressWaiting = false;
          pageFocusStatus = 2;
        });
      }
    });
  }

  void cancelLongPress() {
    if(pageFocusStatus != 0) return;
    int tick = countdownTimer == null? 0 : countdownTimer!.tick;
    if(tick < 3) {
      longPress3STimer?.cancel();
      if(mounted) {
        setState(() {
          longPressWaiting = false;
        });
      }
      startFocus(false);
    } else {
      longPress3STimer?.cancel();
      _stop();
      setState(() {
        longPressWaiting = false;
        pageFocusStatus = 2;
      });
    }
  }

  String timeInt2String(int time) {
    int hours = time ~/ 3600; // 使用整除获取小时
    int minutes = (time % 3600) ~/ 60; // 计算剩余分钟
    int remainingSeconds = time % 60; // 计算剩余秒数

    // 格式化为 hh:mm:ss 形式
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  // 辅助函数，用于确保数字为两位数
  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  void showThemeDialog(int index, Function(int) func) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context)
    {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
          width: screenWidth(context),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 28,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  SizedBox(width: 16, height: 16, child: buildImage('${PAGE_ADD}/theme')),
                  SizedBox(width: 8,),
                  buildText('Theme Color', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                  Spacer(flex: 1,)
                ],
              ),

              SizedBox(height: 66,),


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
                          Visibility(visible: index == 0,child: Column(
                            children: [
                              Spacer(flex: 1,),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                ],
                              )
                            ],
                          ),)
                        ],
                      ), onTap: () {
                        setState(() {
                          index = 0;
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
                          Visibility(visible: index == 1,child: Column(
                            children: [
                              Spacer(flex: 1,),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                ],
                              )
                            ],
                          ),)
                        ],
                      ), onTap: () {
                        setState(() {
                          index = 1;
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
                          Visibility(visible: index == 2,child: Column(
                            children: [
                              Spacer(flex: 1,),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                ],
                              )
                            ],
                          ),)
                        ],
                      ), onTap: () {
                        setState(() {
                          index = 2;
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
                          Visibility(visible: index == 3,child: Column(
                            children: [
                              Spacer(flex: 1,),
                              Row(
                                children: [
                                  Spacer(flex: 1,),
                                  SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                ],
                              )
                            ],
                          ),)
                        ],
                      ), onTap: () {
                        setState(() {
                          index = 3;
                        });
                      },),
                    ),

                    SizedBox(width: 32,),
                  ]
              ),

              SizedBox(height: 88,),

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
                    child: buildText('Customize', Colors.white, 16),
                  ),
                ),
                onTap: () {
                  func(index);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      });

    });
  }

  void showMusicDialog(int index, Function(int) func) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context)
        {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: screenWidth(context),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 28,),
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      SizedBox(width: 16, height: 16, child: buildImage('${PAGE_ADD}/music')),
                      SizedBox(width: 8,),
                      buildText('Background Music', Color(0xFF2C2B49), 15, fontWeight: FontWeight.bold),
                      Spacer(flex: 1,)
                    ],
                  ),

                  SizedBox(height: 66,),


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
                              Visibility(visible: index == 0,child: Container(
                                width: 48,
                                height: 48,
                                child: Column(
                                  children: [
                                    Spacer(flex: 1,),
                                    Row(
                                      children: [
                                        Spacer(flex: 1,),
                                        SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                      ],
                                    )
                                  ],
                                ),
                              ),)
                            ],
                          ),
                          SizedBox(height: 12,),
                          buildText('Not have', Color(index == 0? 0xFF1EC691 : 0xFFCACAD1), 12)
                        ],
                      ), onTap: () {
                        setState(() {
                          index = 0;
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
                                Visibility(visible: index == 1,child: Container(
                                  width: 48,
                                  height: 48,
                                  child: Column(
                                    children: [
                                      Spacer(flex: 1,),
                                      Row(
                                        children: [
                                          Spacer(flex: 1,),
                                          SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),)
                              ],
                            ),
                            SizedBox(height: 12,),
                            buildText('pitter-patter', Color(index == 1? 0xFF1EC691 : 0xFFCACAD1), 12)
                          ],
                        ), onTap: () {
                          setState(() {
                            index = 1;
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
                                Visibility(visible: index == 2,child: Container(
                                  width: 48,
                                  height: 48,
                                  child: Column(
                                    children: [
                                      Spacer(flex: 1,),
                                      Row(
                                        children: [
                                          Spacer(flex: 1,),
                                          SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),)
                              ],
                            ),
                            SizedBox(height: 12,),
                            buildText('stream', Color(index == 2? 0xFF1EC691 : 0xFFCACAD1), 12)
                          ],
                        ), onTap: () {
                          setState(() {
                            index = 2;
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
                                Visibility(visible: index == 3,child: Container(
                                  width: 48,
                                  height: 48,
                                  child: Column(
                                    children: [
                                      Spacer(flex: 1,),
                                      Row(
                                        children: [
                                          Spacer(flex: 1,),
                                          SizedBox(width: 24, height: 24, child: buildImage('${PAGE_ADD}/check'),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),)
                              ],
                            ),
                            SizedBox(height: 12,),
                            buildText('light music', Color(index == 3? 0xFF1EC691 : 0xFFCACAD1), 12)
                          ],
                        ), onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },),
                      ),


                      SizedBox(width: 32,),
                    ],
                  ),

                  SizedBox(height: 88,),

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
                        child: buildText('Customize', Colors.white, 16),
                      ),
                    ),
                    onTap: () {
                      func(index);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          });
        });
  }

}
