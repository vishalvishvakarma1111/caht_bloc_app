import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:chat_bloc_app/src/styles/day_view.dart';
import 'package:chat_bloc_app/src/utils/hour_minute.dart';
import 'package:chat_bloc_app/src/utils/utils.dart';
import 'package:chat_bloc_app/src/widgets/zoomable_header_widget.dart';

import '../../my_exports.dart';

/// Contains default builders and formatters.
class DefaultBuilders {
  /// Allows to calculate a top offset according to the specified hour row height.
  static double defaultTopOffsetCalculator(HourMinute time,
      {HourMinute minimumTime = HourMinute.min, double hourRowHeight = 60}) {
    HourMinute relative = time.subtract(minimumTime);
    return (relative.hour + (relative.minute / 60)) * hourRowHeight;
  }

  /// Builds the current time indicator builder.
  static Widget defaultCurrentTimeIndicatorBuilder(
      DayViewStyle dayViewStyle, TopOffsetCalculator topOffsetCalculator, double hoursColumnWidth, bool isRtl) {
    List<Widget> children = [
      if (dayViewStyle.currentTimeRuleHeight > 0 && dayViewStyle.currentTimeRuleColor != null)
        Expanded(
          child: Container(
            height: dayViewStyle.currentTimeRuleHeight,
            color: dayViewStyle.currentTimeRuleColor,
          ),
        ),
      if (dayViewStyle.currentTimeCircleRadius > 0 && dayViewStyle.currentTimeCircleColor != null)
        Container(
          height: dayViewStyle.currentTimeCircleRadius * 2,
          width: dayViewStyle.currentTimeCircleRadius * 2,
          decoration: BoxDecoration(
            color: dayViewStyle.currentTimeCircleColor,
            shape: BoxShape.circle,
          ),
        ),
    ];

    final timeIndicatorHight = math.max(
      dayViewStyle.currentTimeRuleHeight,
      dayViewStyle.currentTimeCircleRadius * 2,
    );

    return Positioned(
      top: topOffsetCalculator(HourMinute.now()) - timeIndicatorHight / 2,
      left: isRtl ? 0 : hoursColumnWidth,
      right: isRtl ? hoursColumnWidth : 0,
      child: Row(children: children),
    );
  }

  /// Builds the time displayed on the side border.
  static Widget defaultHoursColumnTimeBuilder(HoursColumnStyle hoursColumnStyle, HourMinute time) {
    return Text(
      '${Utils.addLeadingZero(time.hour)}:${Utils.addLeadingZero(time.minute)}',
      style: hoursColumnStyle.textStyle,
    );
  }
}
