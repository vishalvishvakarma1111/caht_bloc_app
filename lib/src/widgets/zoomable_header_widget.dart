import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:chat_bloc_app/src/styles/day_view.dart';
import 'package:chat_bloc_app/src/styles/hours_column.dart';
import 'package:chat_bloc_app/src/utils/builders.dart';
import 'package:chat_bloc_app/src/utils/hour_minute.dart';

/// Allows to calculate a top offset from a given hour.
typedef TopOffsetCalculator = double Function(HourMinute time);

/// Triggered when the hours column has been tapped down.
typedef HoursColumnTapCallback = Function(HourMinute time);

/// Triggered when the day bar has been tapped down.
typedef DayBarTapCallback = Function(DateTime date);

/// Allows to build the current time indicator (rule and circle).
typedef CurrentTimeIndicatorBuilder = Widget? Function(
    DayViewStyle dayViewStyle, TopOffsetCalculator topOffsetCalculator, double hoursColumnWidth, bool isRtl);

/// Allows to build the time displayed on the side border.
typedef HoursColumnTimeBuilder = Widget? Function(HoursColumnStyle dayViewStyle, HourMinute time);

/// Allows to build the background decoration below single time displayed on the side border.
typedef HoursColumnBackgroundBuilder = Decoration? Function(HourMinute time);

/// A widget which is showing both headers and can be zoomed.
abstract class ZoomableHeadersWidget<S> extends StatefulWidget {
  /// The widget style.
  final S style;

  /// The hours column style.
  final HoursColumnStyle hoursColumnStyle;

  /// Whether the widget should automatically be placed in a scrollable widget.
  final bool inScrollableWidget;

  /// The minimum time to display.
  final HourMinute minimumTime;

  /// The maximum time to display.
  final HourMinute maximumTime;

  /// The initial visible time. Defaults to the current hour of the day (if possible).
  final DateTime initialTime;

  /// The current time indicator builder.
  final CurrentTimeIndicatorBuilder? currentTimeIndicatorBuilder;

  /// Building method for building the time displayed on the side border.
  final HoursColumnTimeBuilder? hoursColumnTimeBuilder;

  /// Building method for building background decoration below single time displayed on the side border.
  final HoursColumnBackgroundBuilder? hoursColumnBackgroundBuilder;

  /// Triggered when the hours column has been tapped down.
  final HoursColumnTapCallback? onHoursColumnTappedDown;

  /// Triggered when the day bar has been tapped down.
  final DayBarTapCallback? onDayBarTappedDown;

  /// Whether the widget should be aligned from right to left.
  final bool isRTL;

  /// Creates a new zoomable headers widget instance.
  const ZoomableHeadersWidget({
    Key? key,
    required this.style,
    required this.hoursColumnStyle,
    required this.inScrollableWidget,
    required this.minimumTime,
    required this.maximumTime,
    required this.initialTime,
    this.currentTimeIndicatorBuilder,
    this.onHoursColumnTappedDown,
    this.onDayBarTappedDown,
    this.hoursColumnTimeBuilder,
    this.hoursColumnBackgroundBuilder,
    required this.isRTL,
  }) : super(key: key);
}

/// An abstract widget state that shows both headers and can be zoomed.
abstract class ZoomableHeadersWidgetState<W extends ZoomableHeadersWidget> extends State<W> {
  /// The current hour row height.
  late double hourRowHeight;

  /// The vertical scroll controller.
  ScrollController? verticalScrollController;

  @override
  void initState() {
    super.initState();
    hourRowHeight = _calculateHourRowHeight();

    if (widget.inScrollableWidget) {
      verticalScrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    verticalScrollController?.dispose();
    super.dispose();
  }

  /// Returns the current day view style.
  DayViewStyle get currentDayViewStyle;

  /// Schedules a scroll to the default hour.
  void scheduleScrollToInitialTime() {
    if (shouldScrollToInitialTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToInitialTime());
    }
  }

  /// Checks whether the widget should scroll to current time.
  bool get shouldScrollToInitialTime =>
      widget.minimumTime.atDate(widget.initialTime).isBefore(widget.initialTime) &&
      widget.maximumTime.atDate(widget.initialTime).isAfter(widget.initialTime);

  /// Scrolls to the initial time.
  void scrollToInitialTime() {
    if (mounted && verticalScrollController != null && verticalScrollController!.hasClients) {
      double topOffset = calculateTopOffset(HourMinute.fromDateTime(dateTime: widget.initialTime));
      verticalScrollController!.jumpTo(math.min(topOffset, verticalScrollController!.position.maxScrollExtent));
    }
  }

  /// Calculates the top offset of a given time.
  double calculateTopOffset(HourMinute time, {HourMinute? minimumTime, double? hourRowHeight}) =>
      DefaultBuilders.defaultTopOffsetCalculator(time,
          minimumTime: minimumTime ?? widget.minimumTime, hourRowHeight: hourRowHeight ?? this.hourRowHeight);

  /// Calculates the widget height.
  double calculateHeight([double? hourRowHeight]) =>
      calculateTopOffset(widget.maximumTime, hourRowHeight: hourRowHeight);

  /// Calculates the hour row height.
  double _calculateHourRowHeight() {
    return currentDayViewStyle.hourRowHeight;
  }
}
