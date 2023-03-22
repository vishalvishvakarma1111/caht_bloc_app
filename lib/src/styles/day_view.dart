import 'package:flutter/material.dart';
 import 'package:chat_bloc_app/src/utils/hour_minute.dart';
import 'package:chat_bloc_app/src/utils/utils.dart';
import 'package:chat_bloc_app/src/widgets/day_view.dart';
import 'package:chat_bloc_app/src/widgets/hours_column.dart';
import 'package:chat_bloc_app/src/widgets/zoomable_header_widget.dart';

/// Allows to style a day view.
class DayViewStyle {
  final double hourRowHeight;

  final Color? backgroundColor;

  final Color? backgroundRulesColor;

  /// The current time rule color, i.e., the color of the horizontal line in the day view column,
  /// positioned at the current time of the day. It is only shown if the DayView's date is today.
  ///
  /// Defaults to [Colors.pink].
  final Color? currentTimeRuleColor;

  /// The current time rule height.
  ///
  /// Defaults to 1 pixel.
  final double currentTimeRuleHeight;

  /// The current time circle color. This is a small circle to be shown along with the horizontal
  /// time rule in the hours column, typically colored the same as [currentTimeRuleColor].
  ///
  /// If null, the circle is not drawn.
  final Color? currentTimeCircleColor;

  /// The current time circle radius.
  ///
  /// Defaults to 7.5 pixels.
  final double currentTimeCircleRadius;

  /// The current time rule position, i.e., the position of the current time circle in the day view column.
  ///
  /// Defaults to [CurrentTimeCirclePosition.right].

  /// Creates a new day view style instance.
  const DayViewStyle({
    double? headerSize,
    double? hourRowHeight,
    Color? backgroundColor,
    this.backgroundRulesColor = const Color(0x1A000000),
    this.currentTimeRuleColor = Colors.pink,
    double? currentTimeRuleHeight,
    this.currentTimeCircleColor,
    double? currentTimeCircleRadius,
  })  : hourRowHeight = (hourRowHeight ?? 60) < 0 ? 0 : (hourRowHeight ?? 60),
        backgroundColor = Colors.white,
        currentTimeRuleHeight = (currentTimeRuleHeight ?? 1) < 0 ? 0 : (currentTimeRuleHeight ?? 1),
        currentTimeCircleRadius = (currentTimeCircleRadius ?? 7.5) < 0 ? 0 : (currentTimeCircleRadius ?? 7.5),
        super();

  /// Allows to automatically customize the day view background color according to the specified date.
  DayViewStyle.fromDate({
    required DateTime date,
    double? headerSize,
    double? hourRowHeight,
    Color backgroundRulesColor = const Color(0x1A000000),
    Color currentTimeRuleColor = Colors.pink,
    double? currentTimeRuleHeight,
    Color? currentTimeCircleColor,
  }) : this(
          headerSize: headerSize,
          hourRowHeight: hourRowHeight,
          backgroundColor: Utils.sameDay(date) ? const Color(0xFFE3F5FF) : null,
          backgroundRulesColor: backgroundRulesColor,
          currentTimeRuleColor: currentTimeRuleColor,
          currentTimeRuleHeight: currentTimeRuleHeight,
          currentTimeCircleColor: currentTimeCircleColor,
        );

  /// Creates the background painter.
  CustomPainter createBackgroundPainter({
    required DayView dayView,
    required TopOffsetCalculator topOffsetCalculator,
  }) =>
      _EventsColumnBackgroundPainter(
        minimumTime: dayView.minimumTime,
        maximumTime: dayView.maximumTime,
        topOffsetCalculator: topOffsetCalculator,
        dayViewStyle: this,
        interval: dayView.hoursColumnStyle.interval,

      );
}

/// The events column background painter.
class _EventsColumnBackgroundPainter extends CustomPainter {
  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The top offset calculator.
  final TopOffsetCalculator topOffsetCalculator;

  /// The day view style.
  final DayViewStyle dayViewStyle;

  /// The interval between two lines.
  final Duration interval;

  /// Creates a new events column background painter.
  const _EventsColumnBackgroundPainter({
    required this.minimumTime,
    required this.maximumTime,
    required this.topOffsetCalculator,
    required this.dayViewStyle,
    required this.interval,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dayViewStyle.backgroundColor != null) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = dayViewStyle.backgroundColor!);
    }

    if (dayViewStyle.backgroundRulesColor != null) {
      final List<HourMinute> sideTimes = HoursColumn.getSideTimes(minimumTime, maximumTime, interval);

      for (HourMinute time in sideTimes) {
        double topOffset = topOffsetCalculator(time);
        var a = 10;
        canvas.drawLine(Offset(0, topOffset + a), Offset(size.width, topOffset + a),
            Paint()..color = dayViewStyle.backgroundRulesColor!);
      }
    }
  }

  @override
  bool shouldRepaint(_EventsColumnBackgroundPainter oldDayViewBackgroundPainter) {
    return dayViewStyle.backgroundColor != oldDayViewBackgroundPainter.dayViewStyle.backgroundColor ||
        dayViewStyle.backgroundRulesColor != oldDayViewBackgroundPainter.dayViewStyle.backgroundRulesColor ||
        topOffsetCalculator != oldDayViewBackgroundPainter.topOffsetCalculator;
  }
}
