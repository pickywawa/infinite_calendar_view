import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controller/events_controller.dart';
import '../../events/event.dart';
import '../../events/event_arranger.dart';
import '../../events_planner.dart';
import '../../painters/events_painters.dart';
import '../../utils/extension.dart';
import 'interactive_slot.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    super.key,
    required this.controller,
    required this.textDirection,
    required this.day,
    required this.todayColor,
    required this.daySeparationWidthPadding,
    required this.plannerHeight,
    required this.heightPerMinute,
    required this.dayWidth,
    required this.dayEventsArranger,
    required this.dayParam,
    required this.columnsParam,
    required this.startColumnIndex,
    required this.currentHourIndicatorParam,
    required this.currentHourIndicatorColor,
    required this.offTimesParam,
    required this.showMultiDayEvents,
  });

  final EventsController controller;
  final TextDirection textDirection;
  final DateTime day;
  final Color? todayColor;
  final double daySeparationWidthPadding;
  final double plannerHeight;
  final double heightPerMinute;
  final double dayWidth;
  final EventArranger dayEventsArranger;
  final DayParam dayParam;
  final ColumnsParam columnsParam;
  final int startColumnIndex;
  final CurrentHourIndicatorParam currentHourIndicatorParam;
  final Color currentHourIndicatorColor;
  final OffTimesParam offTimesParam;
  final bool showMultiDayEvents;

  @override
  Widget build(BuildContext context) {
    var isToday = DateUtils.isSameDay(day, DateTime.now());
    var dayBackgroundColor =
        isToday && todayColor != null ? todayColor : dayParam.dayColor;
    var width = dayWidth - (daySeparationWidthPadding * 2);
    var endColumnIndex = min(
        columnsParam.maxColumns != null
            ? startColumnIndex + columnsParam.maxColumns!
            : columnsParam.columns,
        columnsParam.columns);
    var offTimesOfDay = offTimesParam.offTimesDayRanges[day];
    var offTimesDefaultColor = context.isDarkMode
        ? Theme.of(context).colorScheme.surface.lighten(0.03)
        : const Color(0xFFF4F4F4);

    return Padding(
      padding: EdgeInsets.only(
        left: daySeparationWidthPadding,
        right: daySeparationWidthPadding,
        top: dayParam.dayTopPadding,
        bottom: dayParam.dayBottomPadding,
      ),
      child: MouseRegion(
        onHover: dayParam.slotSelectionParam.enableHoverSlotSelection
            ? (event) => onSlotHover(width, event.localPosition)
            : null,
        onExit: dayParam.slotSelectionParam.enableHoverSlotSelection
            ? (_) {
                if (!controller.slotSelectionFixed) clearSlotSelection();
              }
            : null,
        child: GestureDetector(
          onTapUp: (details) => onSlotEvent(width, details.localPosition.dx,
              details.localPosition.dy, true, false, false),
          onDoubleTapDown: (details) => onSlotEvent(
              width,
              details.localPosition.dx,
              details.localPosition.dy,
              false,
              true,
              false),
          onLongPressStart: (details) => onSlotEvent(
              width,
              details.localPosition.dx,
              details.localPosition.dy,
              false,
              false,
              true),
          onLongPressMoveUpdate: (details) {
            if (dayParam.slotSelectionParam.enableLongPressSlotSelection) {
              var slotSelection = controller.slotSelectionNotifier.value;
              if (slotSelection != null) {
                final minutesDelta =
                    details.localOffsetFromOrigin.dy / heightPerMinute;
                var minutesDeltaRound = dayParam.onSlotRoundAlwaysBefore
                    ? dayParam.onSlotMinutesRound *
                        (minutesDelta / dayParam.onSlotMinutesRound).floor()
                    : dayParam.onSlotMinutesRound *
                        (minutesDelta / dayParam.onSlotMinutesRound).round();
                final daysDelta =
                    (details.localOffsetFromOrigin.dx / dayWidth).round();
                final newStart = slotSelection.initialStartDateTime
                    .addCalendarDays(daysDelta)
                    .add(Duration(minutes: minutesDeltaRound));
                controller.slotSelectionNotifier.value = SlotSelection(
                  slotSelection.columnIndex,
                  slotSelection.initialStartDateTime,
                  newStart,
                  slotSelection.durationInMinutes,
                );
              }
            }
          },
          child: Stack(
            children: [
              // offSet all days painter
              Row(
                textDirection: textDirection,
                children: [
                  for (var column = startColumnIndex;
                      column < endColumnIndex;
                      column++)
                    Container(
                      width: columnsParam.getColumSize(width, column),
                      height: plannerHeight,
                      decoration: BoxDecoration(color: dayBackgroundColor),
                      child: CustomPaint(
                        foregroundPainter: offTimesParam.offTimesAllDaysPainter
                                ?.call(
                                    column,
                                    day,
                                    isToday,
                                    heightPerMinute,
                                    offTimesParam.offTimesAllDaysRanges,
                                    offTimesParam.offTimesColor ??
                                        offTimesDefaultColor) ??
                            OffSetAllDaysPainter(
                                isToday,
                                heightPerMinute,
                                offTimesParam.offTimesAllDaysRanges,
                                offTimesParam.offTimesColor ??
                                    offTimesDefaultColor),
                      ),
                    ),
                ],
              ),

              // offSet particular days painter
              if (offTimesOfDay != null)
                Row(
                  textDirection: textDirection,
                  children: [
                    for (var column = startColumnIndex;
                        column < endColumnIndex;
                        column++)
                      SizedBox(
                        width: columnsParam.getColumSize(width, column),
                        height: plannerHeight,
                        child: CustomPaint(
                          foregroundPainter: offTimesParam.offTimesDayPainter
                                  ?.call(
                                      column,
                                      day,
                                      isToday,
                                      heightPerMinute,
                                      offTimesOfDay,
                                      offTimesParam.offTimesColor ??
                                          offTimesDefaultColor) ??
                              OffSetAllDaysPainter(
                                  false,
                                  heightPerMinute,
                                  offTimesOfDay,
                                  offTimesParam.offTimesColor ??
                                      offTimesDefaultColor),
                        ),
                      ),
                  ],
                ),

              // lines painters
              SizedBox(
                width: width,
                height: plannerHeight,
                child: CustomPaint(
                  foregroundPainter: dayParam.dayCustomPainter
                          ?.call(heightPerMinute, isToday) ??
                      LinesPainter(
                        heightPerMinute: heightPerMinute,
                        isToday: isToday,
                        lineColor: Theme.of(context).colorScheme.outlineVariant,
                      ),
                ),
              ),

              // columns painters
              if (columnsParam.columns > 1)
                SizedBox(
                  width: width,
                  height: plannerHeight,
                  child: CustomPaint(
                    foregroundPainter: columnsParam.columnCustomPainter?.call(
                          width,
                          min(columnsParam.maxColumns ?? columnsParam.columns,
                              columnsParam.columns),
                        ) ??
                        ColumnPainter(
                          width: width,
                          columnsParam: columnsParam,
                          lineColor:
                              Theme.of(context).colorScheme.outlineVariant,
                        ),
                  ),
                ),

              // events
              Row(
                textDirection: textDirection,
                children: [
                  for (var column = startColumnIndex;
                      column < endColumnIndex;
                      column++)
                    EventsListWidget(
                      // rebuild when column index change
                      key: ValueKey(column),
                      controller: controller,
                      columIndex: column,
                      day: day,
                      plannerHeight: plannerHeight -
                          (dayParam.dayTopPadding + dayParam.dayBottomPadding),
                      heightPerMinute: heightPerMinute,
                      dayWidth: columnsParam.getColumSize(width, column),
                      dayEventsArranger: dayEventsArranger,
                      dayParam: dayParam,
                      showMultiDayEvents: showMultiDayEvents,
                    ),
                ],
              ),

              // time line indicator
              if (currentHourIndicatorParam.currentHourIndicatorLineVisibility)
                SizedBox(
                  width: width,
                  height: plannerHeight,
                  child: CustomPaint(
                    foregroundPainter: currentHourIndicatorParam
                            .currentHourIndicatorCustomPainter
                            ?.call(heightPerMinute, isToday) ??
                        TimeIndicatorPainter(
                          heightPerMinute,
                          isToday,
                          currentHourIndicatorColor,
                        ),
                  ),
                ),

              // slot selection
              ValueListenableBuilder<SlotSelection?>(
                valueListenable: controller.slotSelectionNotifier,
                builder: (context, slot, _) {
                  if (slot != null &&
                      DateUtils.isSameDay(slot.startDateTime, day)) {
                    var columnPosition =
                        columnsParam.getColumPositions(width, slot.columnIndex);
                    return Positioned(
                      top: heightPerMinute * slot.startDateTime.totalMinutes,
                      height: heightPerMinute * slot.durationInMinutes,
                      left: columnPosition[0],
                      width: columnPosition[1] - columnPosition[0],
                      child: dayParam.slotSelectionParam.slotSelectionBuilder
                              ?.call(
                            slot,
                            width,
                            dayParam,
                            columnsParam,
                            heightPerMinute,
                            (SlotSelection? updatedSlot) {
                              controller.slotSelectionNotifier.value =
                                  updatedSlot;
                              dayParam.slotSelectionParam.onSlotSelectionChange
                                  ?.call(updatedSlot);
                            },
                          ) ??
                          InteractiveSlot(
                            slot: slot,
                            dayWidth: width,
                            dayParam: dayParam,
                            columnsParam: columnsParam,
                            heightPerMinute: heightPerMinute,
                            mouseCursor: dayParam.slotSelectionParam
                                        .enableHoverSlotSelection &&
                                    (!dayParam.slotSelectionParam
                                            .fixHoverSlotSelectionOnTap ||
                                        !controller.slotSelectionFixed)
                                ? SystemMouseCursors.click
                                : dayParam.slotSelectionParam
                                        .canDragSlotSelectionAfterShow
                                    ? SystemMouseCursors.grab
                                    : SystemMouseCursors.click,
                            dragWithoutLongPress:
                                controller.slotSelectionFixed &&
                                    dayParam.slotSelectionParam
                                        .enableHoverSlotSelection,
                            hideResizeHandles: dayParam.slotSelectionParam
                                    .enableHoverSlotSelection &&
                                dayParam.slotSelectionParam
                                    .fixHoverSlotSelectionOnTap &&
                                !controller.slotSelectionFixed,
                            onTapIntercept: () {
                              var param = dayParam.slotSelectionParam;
                              if (param.enableHoverSlotSelection &&
                                  param.fixHoverSlotSelectionOnTap &&
                                  !controller.slotSelectionFixed) {
                                controller.slotSelectionFixed = true;
                                // rebuild slot to update mouse cursor
                                var s = controller.slotSelectionNotifier.value!;
                                controller.slotSelectionNotifier.value =
                                    SlotSelection(
                                  s.columnIndex,
                                  s.initialStartDateTime,
                                  s.startDateTime,
                                  s.durationInMinutes,
                                );
                                return true;
                              }
                              return false;
                            },
                            onChanged: (SlotSelection? updatedSlot) {
                              controller.slotSelectionNotifier.value =
                                  updatedSlot;
                              dayParam.slotSelectionParam.onSlotSelectionChange
                                  ?.call(updatedSlot);
                            },
                          ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearSlotSelection() {
    controller.slotSelectionFixed = false;
    if (controller.slotSelectionNotifier.value != null) {
      controller.slotSelectionNotifier.value = null;
      dayParam.slotSelectionParam.onSlotSelectionChange?.call(null);
    }
  }

  void onSlotHover(double width, Offset position) {
    // floor so the slot always contains the pointer
    if (controller.slotSelectionFixed &&
        controller.slotSelectionNotifier.value != null) {
      return;
    }
    controller.slotSelectionFixed = false;
    var roundDate = getRoundDateTime(position.dy, alwaysBefore: true);
    var column = columnsParam.getColumnIndex(width, position.dx);
    var slotSelectionParam = dayParam.slotSelectionParam;
    int duration = slotSelectionParam.slotSelectionDefaultDurationInMinutes
            ?.call(column, roundDate) ??
        DayParam.defaultSlotSelectionDurationInMinutes;
    if (slotSelectionParam.hideHoverSlotSelectionOnEventConflict) {
      var slotEnd = roundDate.add(Duration(minutes: duration));
      var hasConflict = controller
              .getFilteredDayEvents(
                day,
                returnFullDayEvent: false,
                returnMultiFullDayEvents: false,
              )
              ?.any((e) =>
                  e.columnIndex == column &&
                  (slotSelectionParam.hoverConflictEventTypes
                          ?.contains(e.eventType) ??
                      true) &&
                  e.startTime.isBefore(slotEnd) &&
                  e.endTime!.isAfter(roundDate)) ??
          false;
      if (hasConflict) {
        clearSlotSelection();
        return;
      }
    }
    var current = controller.slotSelectionNotifier.value;
    if (current != null &&
        current.columnIndex == column &&
        current.startDateTime == roundDate) {
      return;
    }
    controller.slotSelectionNotifier.value =
        SlotSelection(column, roundDate, roundDate, duration);
    slotSelectionParam.onSlotSelectionChange
        ?.call(controller.slotSelectionNotifier.value);
  }

  void onSlotEvent(
    double width,
    double dx,
    double dy,
    bool tap,
    bool doubleTap,
    bool longPress,
  ) {
    var exactDate = getExactDateTime(dy);
    var roundDate = getRoundDateTime(dy);
    var column = columnsParam.getColumnIndex(width, dx);
    var eventFunction = tap
        ? dayParam.onSlotTap
        : doubleTap
            ? dayParam.onSlotDoubleTap
            : dayParam.onSlotLongTap;
    eventFunction?.call(column, exactDate, roundDate);

    var slotSelectionParam = dayParam.slotSelectionParam;

    // selection follows the mouse in hover mode
    if (slotSelectionParam.enableHoverSlotSelection) {
      if (controller.slotSelectionFixed &&
          slotSelectionParam.clearWhenBackgroundTap) {
        clearSlotSelection();
      }
      return;
    }

    // reset slot selection
    if (controller.slotSelectionNotifier.value != null &&
        slotSelectionParam.clearWhenBackgroundTap) {
      controller.slotSelectionNotifier.value = null;
      slotSelectionParam.onSlotSelectionChange?.call(null);
    }
    // init slot selection
    else if ((tap && slotSelectionParam.enableTapSlotSelection) ||
        (doubleTap && slotSelectionParam.enableDoubleTapSlotSelection) ||
        (longPress && slotSelectionParam.enableLongPressSlotSelection)) {
      int duration = slotSelectionParam.slotSelectionDefaultDurationInMinutes
              ?.call(column, roundDate) ??
          DayParam.defaultSlotSelectionDurationInMinutes;
      controller.slotSelectionNotifier.value =
          SlotSelection(column, roundDate, roundDate, duration);
      slotSelectionParam.onSlotSelectionChange
          ?.call(controller.slotSelectionNotifier.value);
    }
  }

  // wall-clock date from minutes since midnight (Duration.add shifts by 1h on DST days)
  DateTime _dayMinutesToDate(int minutes) =>
      DateTime(day.year, day.month, day.day, 0, minutes);

  DateTime getExactDateTime(double dy) {
    var dayMinute = dy / heightPerMinute;
    return _dayMinutesToDate(dayMinute.toInt());
  }

  // Round to nearest multiple of dayParam.onSlotMinutesRound minutes
  DateTime getRoundDateTime(double dy, {bool alwaysBefore = false}) {
    var dayMinute = dy / heightPerMinute;
    var dayMinuteRounded = alwaysBefore || dayParam.onSlotRoundAlwaysBefore
        ? dayParam.onSlotMinutesRound *
            (dayMinute / dayParam.onSlotMinutesRound).floor()
        : dayParam.onSlotMinutesRound *
            (dayMinute / dayParam.onSlotMinutesRound).round();
    return _dayMinutesToDate(dayMinuteRounded.toInt());
  }
}

class EventsListWidget extends StatefulWidget {
  const EventsListWidget({
    super.key,
    required this.controller,
    required this.day,
    required this.columIndex,
    required this.plannerHeight,
    required this.heightPerMinute,
    required this.dayWidth,
    required this.dayEventsArranger,
    required this.dayParam,
    required this.showMultiDayEvents,
  });

  final EventsController controller;
  final int columIndex;
  final DateTime day;
  final double plannerHeight;
  final double heightPerMinute;
  final double dayWidth;
  final EventArranger dayEventsArranger;
  final DayParam dayParam;
  final bool showMultiDayEvents;

  @override
  State<EventsListWidget> createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  List<Event>? events;
  var organizedEvents = <OrganizedEvent>[];
  late double heightPerMinute;
  late VoidCallback eventListener;

  @override
  void initState() {
    super.initState();
    heightPerMinute = widget.heightPerMinute;
    events = getDayColumnEvents();
    organizedEvents = getOrganizedEvents(events);
    eventListener = () => updateEvents();
    widget.controller.addListener(eventListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  List<Event>? getDayColumnEvents() {
    return widget.controller
        .getFilteredDayEvents(
          widget.day,
          returnMultiDayEvents: widget.showMultiDayEvents,
          returnFullDayEvent: false,
          returnMultiFullDayEvents: false,
        )
        ?.where((e) => e.columnIndex == widget.columIndex)
        .toList();
  }

  List<OrganizedEvent> getOrganizedEvents(List<Event>? events) {
    var arranger = widget.dayEventsArranger;
    return arranger.arrange(
      events: events ?? [],
      height: widget.plannerHeight,
      width: widget.dayWidth,
      heightPerMinute: heightPerMinute,
    );
  }

  void updateEvents() {
    if (mounted) {
      var dayEvents = getDayColumnEvents();

      // update events when pinch to zoom
      if (heightPerMinute != widget.heightPerMinute) {
        setState(() {
          heightPerMinute = widget.heightPerMinute;
          organizedEvents = getOrganizedEvents(events);
        });
      }

      // no update if no change for current day
      if (listEquals(dayEvents, events) == false) {
        setState(() {
          events = dayEvents != null ? [...dayEvents] : null;
          organizedEvents = getOrganizedEvents(events);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var scale = 1.0;
    // dynamically resize event when scale update (without complete arrange)
    if (heightPerMinute != widget.heightPerMinute) {
      scale = widget.heightPerMinute / heightPerMinute;
    }
    return SizedBox(
      height: widget.plannerHeight,
      width: widget.dayWidth,
      child: Stack(
        children: organizedEvents.map((e) => getEventWidget(e, scale)).toList(),
      ),
    );
  }

  Widget getEventWidget(OrganizedEvent organizedEvent, double scale) {
    var left = organizedEvent.left;
    var top = organizedEvent.top * scale;
    var right = organizedEvent.right;
    var bottom = organizedEvent.bottom * scale;
    var height = widget.plannerHeight - (bottom + top);
    var width = widget.dayWidth - (left + right);

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: widget.dayParam.dayEventBuilder != null
          ? widget.dayParam.dayEventBuilder!
              .call(organizedEvent.event, height, width, heightPerMinute)
          : DefaultDayEvent(
              title: organizedEvent.event.title,
              description: organizedEvent.event.description,
              color: organizedEvent.event.color,
              textColor: organizedEvent.event.textColor,
              height: height,
              width: width,
            ),
    );
  }
}

class DefaultDayEvent extends StatelessWidget {
  const DefaultDayEvent({
    super.key,
    required this.height,
    required this.width,
    this.child,
    this.title,
    this.description,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.titleFontSize = 14,
    this.descriptionFontSize = 10,
    this.horizontalPadding = 4,
    this.verticalPadding = 4,
    this.eventMargin = const EdgeInsets.all(1),
    this.roundBorderRadius = 3,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  final Widget? child;
  final String? title;
  final String? description;
  final Color color;
  final double height;
  final double width;
  final Color textColor;
  final double titleFontSize;
  final double descriptionFontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final EdgeInsetsGeometry? eventMargin;
  final double roundBorderRadius;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;

  static final minHeight = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: eventMargin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(roundBorderRadius),
        child: Material(
          child: InkWell(
            onTap: onTap,
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            child: Ink(
              color: color,
              width: width,
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: height > minHeight ? verticalPadding : 0,
                ),
                child: child ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title?.isNotEmpty == true && height > 15)
                          Flexible(
                            child: Text(
                              title!,
                              style: TextStyle(
                                color: textColor,
                                fontSize: titleFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: height > 40 ? 2 : 1,
                            ),
                          ),
                        if (description?.isNotEmpty == true && height > 40)
                          Flexible(
                            child: Text(
                              description!,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: descriptionFontSize),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 4,
                            ),
                          ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
