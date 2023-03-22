import 'package:flutter/material.dart';

class HoursColumnStyle {
  final double width;
  final Duration interval;
  final TextStyle? textStyle;
  final Color? color;

  const HoursColumnStyle({
    TextStyle? textStyle,
    double? width,
    Color? color,
    Alignment? textAlignment,
    Duration? interval,
  })  : textStyle = textStyle ?? const TextStyle(color: Colors.black54),
        width = (width ?? 60) < 0 ? 0 : (width ?? 60),
        color = color ?? Colors.white,
        interval = interval ?? const Duration(hours: 1);
}
