

class FocusStatisticsInfo {
  List<StatisticsLastDay> list = [];
  int totalFocusSuccessNumber = 0;
  int totalFocusFailureNumber = 0;
  int totalFocusSuccessTime = 0; //单位为s
  int totalFocusFailureTime = 0; //单位为s

  int todayFocusSuccessNumber = 0;
  int todayFocusFailureNumber = 0;
  int todayFocusSuccessTime = 0; //单位为s
  int todayFocusFailureTime = 0; //单位为s

  String favoriteModeName = '';
  int favoriteFocusSuccessNumber = 0;
  int favoriteFocusSuccessTime = 0;
}

class StatisticsLastDay {
  String date = '';
  double progress = 0;
  int totalTime = 0;
}