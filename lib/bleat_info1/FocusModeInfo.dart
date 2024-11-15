import 'dart:convert';

class FocusModeInfo {
  String date = '';
  int sys = 0;
  String name = '';
  int focusTime = 25; //默认25min
  int breakTime = 5; //默认5min
  int themeColorIndex = 0; //主题索引位置
  int backgroundMusicIndex = 0; //背景音乐索引位置
  bool endRemind = false; //默认关闭，开启后，当专注倒计时在60s、30s、5s时震动3下做提醒

  FocusModeInfo(
      {String date = '',
      int sys = 0,
      String name = '',
      int focusTime = 25,
      int breakTime = 5,
      int themeColorIndex = 0,
      int backgroundMusicIndex = 0,
      bool endRemind = false}) {
    this.date = date;
    this.sys = sys;
    this.name = name;
    this.focusTime = focusTime;
    this.breakTime = breakTime;
    this.themeColorIndex = themeColorIndex;
    this.backgroundMusicIndex = backgroundMusicIndex;
    this.endRemind = endRemind;
  }

  factory FocusModeInfo.fromJson(Map<String, dynamic> json) {
    return FocusModeInfo(
        date: json['date'],
        sys: json['sys'],
        name: json['name'],
        focusTime: json['focusTime'],
        breakTime: json['breakTime'],
        themeColorIndex: json['themeColorIndex'],
        backgroundMusicIndex: json['backgroundMusicIndex'],
        endRemind: json['endRemind']);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sys': sys,
      'name': name,
      'focusTime': focusTime,
      'breakTime': breakTime,
      'themeColorIndex': themeColorIndex,
      'backgroundMusicIndex': backgroundMusicIndex,
      'endRemind': endRemind
    };
  }

  static Map<String, dynamic> toMap(FocusModeInfo actor) => {
        'date': actor.date,
        'sys': actor.sys,
        'name': actor.name,
        'focusTime': actor.focusTime,
        'breakTime': actor.breakTime,
        'themeColorIndex': actor.themeColorIndex,
        'backgroundMusicIndex': actor.backgroundMusicIndex,
        'endRemind': actor.endRemind
      };

  factory FocusModeInfo.fromMap(Map<String, dynamic> map) {
    return FocusModeInfo(
        date: map['date'],
        sys: map['sys'],
        name: map['name'],
        focusTime: map['focusTime'],
        breakTime: map['breakTime'],
        themeColorIndex: map['themeColorIndex'],
        backgroundMusicIndex: map['backgroundMusicIndex'],
        endRemind: map['endRemind']);
  }

  static String encode(List<FocusModeInfo> actors) => json.encode(
        actors
            .map<Map<String, dynamic>>((actor) => FocusModeInfo.toMap(actor))
            .toList(),
      );

  static List<FocusModeInfo> decode(String actors) =>
      (json.decode(actors) as List<dynamic>)
          .map<FocusModeInfo>((item) => FocusModeInfo.fromJson(item))
          .toList();
}
