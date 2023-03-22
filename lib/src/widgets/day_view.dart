import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:chat_bloc_app/src/event.dart';
import 'package:chat_bloc_app/src/styles/day_view.dart';
import 'package:chat_bloc_app/src/styles/hours_column.dart';
import 'package:chat_bloc_app/src/utils/builders.dart';
import 'package:chat_bloc_app/src/utils/event_grid.dart';
import 'package:chat_bloc_app/src/utils/hour_minute.dart';
import 'package:chat_bloc_app/src/utils/utils.dart';
import 'package:chat_bloc_app/src/widgets/hours_column.dart';
import 'package:chat_bloc_app/src/widgets/zoomable_header_widget.dart';

class DayView extends ZoomableHeadersWidget<DayViewStyle> {
  final List<MyDayViewEvent> events;
  final DateTime date;

  DayView({
    Key? key,
    List<MyDayViewEvent>? events,
    required DateTime date,
    DayViewStyle? style,
    HoursColumnStyle? hoursColumnStyle,
    bool? inScrollableWidget,
    bool? isRTL,
    HourMinute? minimumTime,
    HourMinute? maximumTime,
    HourMinute? initialTime,
    CurrentTimeIndicatorBuilder? currentTimeIndicatorBuilder,
    HoursColumnTimeBuilder? hoursColumnTimeBuilder,
    HoursColumnBackgroundBuilder? hoursColumnBackgroundBuilder,
    HoursColumnTapCallback? onHoursColumnTappedDown,
    DayBarTapCallback? onDayBarTappedDown,
  })  : events = events ?? [],
        date = date.yearMonthDay,
        super(
          key: key,
          style: style ?? DayViewStyle.fromDate(date: date),
          hoursColumnStyle: hoursColumnStyle ?? const HoursColumnStyle(interval: Duration(minutes: 30)),
          inScrollableWidget: inScrollableWidget ?? true,
          isRTL: isRTL ?? false,
          minimumTime: minimumTime ?? HourMinute.min,
          maximumTime: maximumTime ?? HourMinute.max,
          initialTime:
              initialTime?.atDate(date) ?? (Utils.sameDay(date) ? HourMinute.now() : const HourMinute()).atDate(date),
          hoursColumnTimeBuilder: hoursColumnTimeBuilder ?? DefaultBuilders.defaultHoursColumnTimeBuilder,
          hoursColumnBackgroundBuilder: hoursColumnBackgroundBuilder,
          onHoursColumnTappedDown: onHoursColumnTappedDown,
          onDayBarTappedDown: onDayBarTappedDown,
        );

  @override
  State<StatefulWidget> createState() => _DayViewState();
}

/// The day view state.
class _DayViewState extends ZoomableHeadersWidgetState<DayView> {
  /// Contains all events draw properties.
  final Map<MyDayViewEvent, EventDrawProperties> eventsDrawProperties = HashMap();

  /// The flutter week view events.
  late List<MyDayViewEvent> events;

  @override
  void initState() {
    super.initState();
    scheduleScrollToInitialTime();
    reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(createEventsDrawProperties);
      }
    });
  }

  @override
  void didUpdateWidget(DayView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date) {
      scheduleScrollToInitialTime();
    }

    reset();
    createEventsDrawProperties();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget = createMainWidget();
    return mainWidget;
  }

  @override
  DayViewStyle get currentDayViewStyle => widget.style;

  /// Creates the main widget, with a hours column and an events column.
  Widget createMainWidget() {

    ///  adding events in the stack
    List<Widget> children =
        eventsDrawProperties.entries.map((entry) => entry.value.createWidget(context, widget, entry.key)).toList();

    if (widget.hoursColumnStyle.width > 0) {
      children.add(Positioned(
        top: 0,
        right: widget.isRTL ? null : 0,
        child: HoursColumn.fromHeadersWidgetState(parent: this),
      ));
    }

    if (Utils.sameDay(widget.date) &&
        widget.minimumTime.atDate(widget.date).isBefore(DateTime.now()) &&
        widget.maximumTime.atDate(widget.date).isAfter(DateTime.now())) {
      Widget? currentTimeIndicator =
          (widget.currentTimeIndicatorBuilder ?? DefaultBuilders.defaultCurrentTimeIndicatorBuilder)(
              widget.style, calculateTopOffset, widget.hoursColumnStyle.width, widget.isRTL);
      if (currentTimeIndicator != null) {
        children.add(currentTimeIndicator);
      }
    }

    Widget mainWidget = SizedBox(
      height: calculateHeight(),
      child: Stack(children: children..insert(0, createBackground())),
    );

    if (verticalScrollController != null) {
      mainWidget = SingleChildScrollView(
        controller: verticalScrollController,
        child: mainWidget,
      );
    }

    return mainWidget;
  }

  /// Creates the background widgets that should be added to a stack.
  Widget createBackground() => Positioned.fill(
        child: CustomPaint(
          painter: widget.style.createBackgroundPainter(
            dayView: widget,
            topOffsetCalculator: calculateTopOffset,
          ),
        ),
      );

  /// Resets the events positioning.
  void reset() {
    eventsDrawProperties.clear();
    events = List.of(widget.events)..sort();
  }

  /// Creates the events draw properties and add them to the current list.
  void createEventsDrawProperties() {
    EventGrid eventsGrid = EventGrid();
    for (MyDayViewEvent event in List.of(events)) {
      EventDrawProperties drawProperties =
          eventsDrawProperties[event] ?? EventDrawProperties(widget, event, widget.isRTL);
      if (!drawProperties.shouldDraw) {
        events.remove(event);
        continue;
      }

      drawProperties.calculateTopAndHeight(calculateTopOffset);
      if (drawProperties.left == null || drawProperties.width == null) {
        eventsGrid.add(drawProperties);
      }

      eventsDrawProperties[event] = drawProperties;
    }

    if (eventsGrid.drawPropertiesList.isNotEmpty) {
      double eventsColumnWidth = (context.findRenderObject() as RenderBox).size.width - widget.hoursColumnStyle.width;
      eventsGrid.processEvents(widget.hoursColumnStyle.width, eventsColumnWidth);
    }
  }
}
