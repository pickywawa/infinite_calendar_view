import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controller/events_controller.dart';
import '../../events/event.dart';
import '../../events/event_arranger.dart';
import '../../events_planner.dart';
import '../../painters/events_painters.dart';
import '../../utils/extension.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    required this.controller, required this.day, required this.todayColor, required this.daySeparationWidthPadding, required this.plannerHeight, required this.heightPerMinute, required this.dayWidth, required this.dayEventsArranger, required this.dayParam, required this.columnsParam, required this.currentHourIndicatorParam, required this.currentHourIndicatorColor, required this.offTimesParam, required this.showMultiDayEvents, super.key,
  });

  final EventsController controller;
  final DateTime day;
  final Color? todayColor;
  final double daySeparationWidthPadding;
  final double plannerHeight;
  final double heightPerMinute;
  final double dayWidth;
  final EventArranger dayEventsArranger;
  final DayParam dayParam;
  final ColumnsParam columnsParam;
  final CurrentHourIndicatorParam currentHourIndicatorParam;
  final Color currentHourIndicatorColor;
  final OffTimesParam offTimesParam;
  final bool showMultiDayEvents;

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(day, DateTime.now());
    final dayBackgroundColor =
        isToday && todayColor != null ? todayColor : dayParam.dayColor;
    final width = dayWidth - (daySeparationWidthPadding * 2);
    final offTimesOfDay = offTimesParam.offTimesDayRanges[day];
    final offTimesDefaultColor = context.isDarkMode
        ? Theme.of(context).colorScheme.surface.lighten(0.03)
        : const Color(0xFFF4F4F4);

    return Padding(
      padding: EdgeInsets.only(
        left: daySeparationWidthPadding,
        right: daySeparationWidthPadding,
        top: dayParam.dayTopPadding,
        bottom: dayParam.dayBottomPadding,
      ),
      child: GestureDetector(
        onTapUp: (details) => dayParam.onSlotTap?.call(
          columnsParam.getColumnIndex(width, details.localPosition.dx),
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        onLongPressStart: (details) => dayParam.onSlotLongTap?.call(
          columnsParam.getColumnIndex(width, details.localPosition.dx),
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        onDoubleTapDown: (details) => dayParam.onSlotDoubleTap?.call(
          columnsParam.getColumnIndex(width, details.localPosition.dx),
          getExactDateTime(details.localPosition.dy),
          getRoundDateTime(details.localPosition.dy),
        ),
        child: Stack(
          children: [
            // offSet all days painter
            Row(
              children: [
                for (var column = 0; column < columnsParam.columns; column++)
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
                            offTimesParam.offTimesColor ?? offTimesDefaultColor,
                          ) ??
                          OffSetAllDaysPainter(
                            isToday,
                            heightPerMinute,
                            offTimesParam.offTimesAllDaysRanges,
                            offTimesParam.offTimesColor ?? offTimesDefaultColor,
                          ),
                    ),
                  ),
              ],
            ),

            // offSet particular days painter
            if (offTimesOfDay != null)
              Row(
                children: [
                  for (var column = 0; column < columnsParam.columns; column++)
                    SizedBox(
                      width: columnsParam.getColumSize(width, column),
                      height: plannerHeight,
                      child: CustomPaint(
                        foregroundPainter:
                            offTimesParam.offTimesDayPainter?.call(
                                  column,
                                  day,
                                  isToday,
                                  heightPerMinute,
                                  offTimesOfDay,
                                  offTimesParam.offTimesColor ??
                                      offTimesDefaultColor,
                                ) ??
                                OffSetAllDaysPainter(
                                  false,
                                  heightPerMinute,
                                  offTimesOfDay,
                                  offTimesParam.offTimesColor ??
                                      offTimesDefaultColor,
                                ),
                      ),
                    ),
                ],
              ),

            // lines painters
            SizedBox(
              width: width,
              height: plannerHeight,
              child: CustomPaint(
                foregroundPainter: dayParam.dayCustomPainter?.call(
                      heightPerMinute,
                      isToday,
                    ) ??
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
                        columnsParam.columns,
                      ) ??
                      ColumnPainter(
                        width: width,
                        columnsParam: columnsParam,
                        lineColor: Theme.of(context).colorScheme.outlineVariant,
                      ),
                ),
              ),

            // events
            Row(
              children: [
                for (var column = 0; column < columnsParam.columns; column++)
                  EventsListWidget(
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
          ],
        ),
      ),
    );
  }

  DateTime getExactDateTime(double dy) {
    final dayMinute = dy / heightPerMinute;
    return day.withoutTime.add(Duration(minutes: dayMinute.toInt()));
  }

  DateTime getRoundDateTime(double dy) {
    final dayMinute = dy / heightPerMinute;
    final dayMinuteRounded = dayParam.onSlotMinutesRound *
        (dayMinute / dayParam.onSlotMinutesRound)
            .round(); // Round to nearest multiple of 10 minutes
    return day.withoutTime.add(Duration(minutes: dayMinuteRounded));
  }
}

class EventsListWidget extends StatefulWidget {
  const EventsListWidget({
    required this.controller, required this.day, required this.columIndex, required this.plannerHeight, required this.heightPerMinute, required this.dayWidth, required this.dayEventsArranger, required this.dayParam, required this.showMultiDayEvents, super.key,
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
    eventListener = updateEvents;
    widget.controller.addListener(eventListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  List<Event>? getDayColumnEvents() => widget.controller
        .getFilteredDayEvents(
          widget.day,
          returnMultiDayEvents: widget.showMultiDayEvents,
          returnFullDayEvent: false,
          returnMultiFullDayEvents: false,
        )
        ?.where((e) => e.columnIndex == widget.columIndex)
        .toList();

  List<OrganizedEvent> getOrganizedEvents(List<Event>? events) {
    final arranger = widget.dayEventsArranger;
    return arranger.arrange(
      events: events ?? [],
      height: widget.plannerHeight,
      width: widget.dayWidth,
      heightPerMinute: heightPerMinute,
    );
  }

  void updateEvents() {
    if (mounted) {
      final dayEvents = getDayColumnEvents();

      // update events when pinch to zoom
      if (heightPerMinute != widget.heightPerMinute) {
        setState(() {
          heightPerMinute = widget.heightPerMinute;
          organizedEvents = getOrganizedEvents(events);
        });
      }

      // no update if no change for current day
      if (!listEquals(dayEvents, events)) {
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
        children: organizedEvents
            .map(
              (e) => getEventWidget(e, scale),
            )
            .toList(),
      ),
    );
  }

  Widget getEventWidget(OrganizedEvent organizedEvent, double scale) {
    final left = organizedEvent.left;
    final top = organizedEvent.top * scale;
    final right = organizedEvent.right;
    final bottom = organizedEvent.bottom * scale;
    final height = widget.plannerHeight - (bottom + top);
    final width = widget.dayWidth - (left + right);

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: widget.dayParam.dayEventBuilder != null
          ? widget.dayParam.dayEventBuilder!.call(
              organizedEvent.event,
              height,
              width,
              heightPerMinute,
            )
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
    required this.height, required this.width, super.key,
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

  static const minHeight = 30;

  @override
  Widget build(BuildContext context) => Container(
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
                                fontSize: descriptionFontSize,
                              ),
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
