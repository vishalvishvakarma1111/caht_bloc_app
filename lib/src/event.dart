import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:chat_bloc_app/src/utils/utils.dart';
import 'package:chat_bloc_app/src/widgets/day_view.dart';

/// Builds an event text widget.
typedef EventTextBuilder = Widget Function(
    MyDayViewEvent event, BuildContext context, DayView dayView, double height, double width);

/// Represents a flutter week view event.
class MyDayViewEvent extends Comparable<MyDayViewEvent> {
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EventTextBuilder eventTextBuilder;

  MyDayViewEvent({
    required this.title,
    required this.description,
    required DateTime start,
    required DateTime end,
    this.backgroundColor = const Color(0xCC2196F3),
    this.decoration,
    this.textStyle = const TextStyle(color: Colors.white),
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.onTap,
    this.onLongPress,
    required this.eventTextBuilder,
  })  : start = start.yearMonthDayHourMinute,
        end = end.yearMonthDayHourMinute;

  Widget build(BuildContext context, DayView dayView, double height, double width) {
    height = height - (padding?.top ?? 0.0) - (padding?.bottom ?? 0.0);
    width = width - (padding?.left ?? 0.0) - (padding?.right ?? 0.0);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: decoration ?? (backgroundColor != null ? BoxDecoration(color: backgroundColor) : null),
        margin: margin,
        padding: padding,
        child: eventTextBuilder(
          this,
          context,
          dayView,
          math.max(0.0, height),
          math.max(0.0, width),
        ),
      ),
    );
  }

  @override
  int compareTo(MyDayViewEvent other) {
    int result = start.compareTo(other.start);
    if (result != 0) {
      return result;
    }
    return end.compareTo(other.end);
  }
}
