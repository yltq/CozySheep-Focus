import 'dart:convert';

import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';

class FocusAndModeRecord {
  String date = '';
  int sys = 0;
  FocusModeInfo? mode;
  bool focusSuccess = false;
  bool focusFailure = false;
  int focusSuccessTime = 0;//单位为s
  int focusFailureTime = 0;//单位为s

  FocusAndModeRecord(
      {String date = '',
      int sys = 0,
        FocusModeInfo? mode,
        bool focusSuccess = false,
        bool focusFailure = false,
        int focusSuccessTime = 0,
        int focusFailureTime = 0
      }) {
    this.date = date;
    this.sys = sys;
    this.mode = mode;
    this.focusSuccess = focusSuccess;
    this.focusFailure = focusFailure;
    this.focusSuccessTime = focusSuccessTime;
    this.focusFailureTime = focusFailureTime;
  }

  factory FocusAndModeRecord.fromJson(Map<String, dynamic> json) {
    return FocusAndModeRecord(
        date: json['date'],
        sys: json['sys'],
        mode: FocusModeInfo.fromJson(json['mode']),
        focusSuccess: json['focusSuccess'],
        focusFailure: json['focusFailure'],
        focusSuccessTime: json['focusSuccessTime'],
        focusFailureTime: json['focusFailureTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sys': sys,
      'mode': mode?.toJson(),
      'focusSuccess': focusSuccess,
      'focusFailure': focusFailure,
      'focusSuccessTime': focusSuccessTime,
      'focusFailureTime': focusFailureTime
    };
  }

  static Map<String, dynamic> toMap(FocusAndModeRecord actor) => {
        'date': actor.date,
        'sys': actor.sys,
        'mode': actor.mode,
        'focusSuccess': actor.focusSuccess,
        'focusFailure': actor.focusFailure,
        'focusSuccessTime': actor.focusSuccessTime,
        'focusFailureTime': actor.focusFailureTime
      };

  factory FocusAndModeRecord.fromMap(Map<String, dynamic> map) {
    return FocusAndModeRecord(
        date: map['date'],
        sys: map['sys'],
        mode: map['mode'],
        focusSuccess: map['focusSuccess'],
        focusFailure: map['focusFailure'],
        focusSuccessTime: map['focusSuccessTime'],
        focusFailureTime: map['focusFailureTime']);
  }

  static String encode(List<FocusAndModeRecord> actors) => json.encode(
        actors
            .map<Map<String, dynamic>>((actor) => FocusAndModeRecord.toMap(actor))
            .toList(),
      );

  static List<FocusAndModeRecord> decode(String actors) =>
      (json.decode(actors) as List<dynamic>)
          .map<FocusAndModeRecord>((item) => FocusAndModeRecord.fromJson(item))
          .toList();
}
