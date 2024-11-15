

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:listen_bleat/main.dart';
import 'package:listen_bleat/page_history/HistoryPage.dart';

import '../page_add/PlanAddPage.dart';
import '../page_focus/PlanFocusDetailPage.dart';
import '../page_tab/MainTabPage.dart';

Image buildImage(String path, {BoxFit fit = BoxFit.cover, String pre = "assets"}) {
  String imagePath = '$pre$path.png';
  return Image.asset(imagePath, fit: fit);
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String PAGE_START = "/page_start";
String PAGE_MAIN_TAB = "/page_main_tab";
String PAGE_ADD = "/page_add";
String PAGE_FOCUS_DETAIL = "/page_focus_detail";
String PAGE_HISTORY = "/page_history";

final Map<String, WidgetBuilder> routes = {
  PAGE_START: (ctx) => PageStartPage(),
  PAGE_MAIN_TAB: (ctx){
    return MainTabPage();
  },
  PAGE_ADD: (ctx){
    return PlanAddPage();
  },
  PAGE_HISTORY: (ctx) {
    return HistoryPage();
  }
};

final RouteFactory buildRouteFactory = (settings) {
  if (settings.name == PAGE_FOCUS_DETAIL) {
    return MaterialPageRoute(
        builder: (ctx) {
          return PlanFocusDetailPage(mode: settings.arguments as FocusModeInfo);
        }
    );
  }
  return null;
};


String fetchBackgroundMusicBg(int index) {
  if(index == 0) {
    return '/page_main_tab/mode_background0';
  } else if(index == 1) {
    return '/page_main_tab/mode_background1';
  } else if(index == 2){
    return '/page_main_tab/mode_background2';
  } else {
    return '/page_main_tab/mode_background3';
  }
}

String fetchThemeMask(int index) {
  if(index == 0) {
    return '/page_main_tab/mode_mask0';
  } else if(index == 1) {
    return '/page_main_tab/mode_mask1';
  } else if(index == 2){
    return '/page_main_tab/mode_mask2';
  } else {
    return '/page_main_tab/mode_mask3';
  }
}

String fetchPageBackground(int index) {
  if(index == 0) {
    return '/page_main_tab/page_background0';
  } else if(index == 1) {
    return '/page_main_tab/page_background1';
  } else if(index == 2){
    return '/page_main_tab/page_background2';
  } else {
    return '/page_main_tab/page_background3';
  }
}

String fetchBackgroundMusic(int index) {
  if(index == 0) {
    return '';
  } else if(index == 1) {
    return 'detail_music/music_01.mp3';
  } else if(index == 2){
    return 'detail_music/music_02.mp3';
  } else {
    return 'detail_music/music_03.wav';
  }
}

String secondsToOtherTimeString(int s) {
  int hours = s ~/ 3600; // 计算小时
  int minutes = (s % 3600) ~/ 60; // 计算分钟
  int seconds = s % 60; // 计算剩余秒数

  // 格式化输出为 hh:mm:ss
  String formattedTime = '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  return formattedTime;
}

String secondsToOtherTimeStringNoFH(int s) {
  String time = '';
  if (s >= 3600) {
    // 超过1小时
    int hours = s ~/ 3600;
    if(hours > 1) {
      time = '${hours}hours';
    } else {
      time = '${hours}hour';
    }
  } else if (s >= 60) {
    // 超过1分钟
    int minutes = s ~/ 60;
    if(minutes > 1) {
      time = '${minutes}mins';
    } else {
      time = '${minutes}min';
    }
  } else {
    // 小于1分钟
    time = '${s}s';
  }
  return time;
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}


