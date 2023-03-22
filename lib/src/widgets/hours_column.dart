import 'package:flutter/material.dart';
import 'package:chat_bloc_app/src/styles/hours_column.dart';
import 'package:chat_bloc_app/src/utils/builders.dart';
import 'package:chat_bloc_app/src/utils/hour_minute.dart';
import 'package:chat_bloc_app/src/widgets/zoomable_header_widget.dart';

/// A column which is showing a day hours.
class HoursColumn extends StatelessWidget {
  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The top offset calculator.
  final TopOffsetCalculator topOffsetCalculator;

  /// The widget style.
  final HoursColumnStyle style;

  /// Triggered when the hours column has been tapped down.
  final HoursColumnTapCallback? onHoursColumnTappedDown;

  /// The times to display on the side border.
  final List<HourMinute> _sideTimes;

  /// Building method for building the time displayed on the side border.
  final HoursColumnTimeBuilder hoursColumnTimeBuilder;

  /// Creates a new hours column instance.
  HoursColumn({
    Key? key,
    this.minimumTime = HourMinute.min,
    this.maximumTime = HourMinute.max,
    TopOffsetCalculator? topOffsetCalculator,
    this.style = const HoursColumnStyle(),
    this.onHoursColumnTappedDown,
    HoursColumnTimeBuilder? hoursColumnTimeBuilder,
  })  : assert(minimumTime < maximumTime),
        topOffsetCalculator = topOffsetCalculator ?? DefaultBuilders.defaultTopOffsetCalculator,
        hoursColumnTimeBuilder = hoursColumnTimeBuilder ?? DefaultBuilders.defaultHoursColumnTimeBuilder,
        _sideTimes = getSideTimes(minimumTime, maximumTime, style.interval),
        super(key: key);

  /// Creates a new h, super(key: key)ours column instance from a headers widget instance.
  HoursColumn.fromHeadersWidgetState({
    Key? key,
    required ZoomableHeadersWidgetState parent,
  }) : this(
          key: key,
          minimumTime: parent.widget.minimumTime,
          maximumTime: parent.widget.maximumTime,
          topOffsetCalculator: parent.calculateTopOffset,
          style: parent.widget.hoursColumnStyle,
          onHoursColumnTappedDown: parent.widget.onHoursColumnTappedDown,
          hoursColumnTimeBuilder: parent.widget.hoursColumnTimeBuilder,
        );

  @override
  Widget build(BuildContext context) {
    final Widget background;
    background = const SizedBox.shrink();

    Widget child = Container(
      height: topOffsetCalculator(maximumTime),
      width: style.width,
      color: style.color ?? Colors.white,
      child: Stack(
        children: <Widget>[background] +
            _sideTimes
                .map(
                  (time) => Positioned(
                    top: topOffsetCalculator(time) - ((14) / 10),
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: hoursColumnTimeBuilder(style,time),
                    ),
                  ),
                )
                .toList(),
      ),
    );

    if (onHoursColumnTappedDown == null) {
      return child;
    }

    return GestureDetector(
      onTapDown: (details) {
        var hourRowHeight = topOffsetCalculator(minimumTime.add(const HourMinute(hour: 1)));
        double hourMinutesInHour = details.localPosition.dy / hourRowHeight;

        int hour = hourMinutesInHour.floor();
        int minute = ((hourMinutesInHour - hour) * 60).round();
        onHoursColumnTappedDown!(minimumTime.add(HourMinute(hour: hour, minute: minute)));
      },
      child: child,
    );
  }

  /// Creates the side times.
  static List<HourMinute> getSideTimes(HourMinute minimumTime, HourMinute maximumTime, Duration interval) {
    List<HourMinute> sideTimes = [];
    HourMinute currentHour = HourMinute(hour: minimumTime.hour);
    while (currentHour < maximumTime) {
      sideTimes.add(currentHour);
      currentHour = currentHour.add(HourMinute.fromDuration(duration: interval));
    }
    return sideTimes;
  }
}
