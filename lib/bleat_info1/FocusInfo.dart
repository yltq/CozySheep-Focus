import 'dart:convert';

import 'FocusAndModeRecord.dart';

class FocusInfo {
  String date = '';
  int sys = 0;
  int focusSuccessNumber = 0; //关注总次数
  int focusFailureNumber = 0; //中断关注总次数
  int focusSuccessTime = 0; //关注总时长 //单位为s
  int focusFailureTime = 0; //中断关注总时长 //单位为s
  List<FocusAndModeRecord>? modes = []; //关注模式列表

  FocusInfo(
      {String date = '',
      int sys = 0,
      int focusSuccessNumber = 0,
      int focusFailureNumber = 0,
        int focusSuccessTime = 0,
        int focusFailureTime = 0,
      List<FocusAndModeRecord>? modes}) {
    this.date = date;
    this.sys = sys;
    this.focusSuccessNumber = focusSuccessNumber;
    this.focusFailureNumber = focusFailureNumber;
    this.focusSuccessTime = focusSuccessTime;
    this.focusFailureTime = focusFailureTime;
    this.modes = modes;
  }

  factory FocusInfo.fromJson(Map<String, dynamic> json) {
    return FocusInfo(date: json['date'], sys: json['sys'], focusSuccessNumber: json['focusSuccessNumber'],
        focusFailureNumber: json['focusFailureNumber'], focusSuccessTime: json['focusSuccessTime'],
        focusFailureTime: json['focusFailureTime'], modes: List<FocusAndModeRecord>.from(
          json['modes'].map((modeJson) => FocusAndModeRecord.fromJson(modeJson)),
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sys': sys,
      'focusSuccessNumber': focusSuccessNumber,
      'focusFailureNumber': focusFailureNumber,
      'focusSuccessTime': focusSuccessTime,
      'focusFailureTime': focusFailureTime,
      'modes': modes?.map((mode) => mode.toJson()).toList(),
    };
  }

  static Map<String, dynamic> toMap(FocusInfo actor) => {
        'date': actor.date,
        'sys': actor.sys,
        'focusSuccessNumber': actor.focusSuccessNumber,
        'focusFailureNumber': actor.focusFailureNumber,
        'focusSuccessTime': actor.focusSuccessTime,
        'focusFailureTime': actor.focusFailureTime,
        'modes': actor.modes
      };

  factory FocusInfo.fromMap(Map<String, dynamic> map) {
    return FocusInfo(
        date: map['date'], sys: map['sys'], focusSuccessNumber: map['focusSuccessNumber'],
        focusFailureNumber: map['focusFailureNumber'], focusSuccessTime: map['focusSuccessTime'],
        focusFailureTime: map['focusFailureTime'], modes: map['modes']);
  }

  static String encode(List<FocusInfo> actors) => json.encode(
        actors
            .map<Map<String, dynamic>>((actor) => FocusInfo.toMap(actor))
            .toList(),
      );

  static List<FocusInfo> decode(String actors) =>
      (json.decode(actors) as List<dynamic>)
          .map<FocusInfo>((item) => FocusInfo.fromJson(item))
          .toList();
}
