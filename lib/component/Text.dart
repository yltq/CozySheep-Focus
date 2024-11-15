import 'package:flutter/widgets.dart';

Widget buildText(String data, Color color, double fontSize,
    {FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.center,
    TextDecoration decoration = TextDecoration.none,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return Text(data,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: decoration),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign);
}
