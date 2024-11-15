import 'dart:convert';

import 'package:listen_bleat/bleat_info1/FocusInfo.dart';
import 'package:listen_bleat/bleat_info1/FocusModeInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoStore {
  static Future<void> bcFocusRecord(List<FocusInfo> items) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonRecords = items.map((record) => jsonEncode(record.toJson())).toList();
    await prefs.setStringList('focus_record', jsonRecords);
  }

  static Future<List<FocusInfo>> hqFocusRecord() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? jsonRecords = prefs.getStringList('focus_record');
    List<FocusInfo> list = [];
    try {
      if (jsonRecords != null) {
        list = jsonRecords.map((json) => FocusInfo.fromJson(jsonDecode(json))).toList();
        list.sort((a, b) => b.sys.compareTo(a.sys));
        list.forEach((info) {
          info.modes?.sort((a, b) => b.sys.compareTo(a.sys));
        });
      }
    } catch(e) {
      print('list is ${e}');
    }
    return list;
  }

  static Future<void> bcCreatedMode(List<FocusModeInfo> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsData = items.map((item) => FocusModeInfo.toMap(item)).toList();
    await prefs.setString('create_mode', jsonEncode(itemsData));
  }

  static Future<List<FocusModeInfo>> hqCreatedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsData = prefs.getString('create_mode');
    if (itemsData != null) {
      final List<dynamic> decodedData = jsonDecode(itemsData);
      List<FocusModeInfo> list = decodedData.map((item) => FocusModeInfo.fromMap(item)).toList();
      list.sort((a, b) => b.sys.compareTo(a.sys));
      return list;
    } else {
      return [];
    }
  }
  
}