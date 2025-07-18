import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controller/events_controller.dart';
import '../../events/event.dart';
import '../../events_months.dart';
import '../../utils/default_text.dart';
import '../../utils/event_helder.dart';
import '../../utils/extension.dart';
import 'day.dart';

class Week extends StatefulWidget {
  const Week({
    required this.controller, required this.weekParam, required this.weekHeight, required this.daysParam, required this.startOfWeek, required this.maxEventsShowed, super.key,
  });

  final DateTime startOfWeek;
  final WeekParam weekParam;
  final double weekHeight;
  final DaysParam daysParam;
  final EventsController controller;
  final int maxEventsShowed;

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  late VoidCallback eventListener;
  List<List<Event>?> weekEvents = [];
  List<List<Event?>> weekShowedEvents = [];

  @override
  void initState() {
    super.initState();
    updateEvents();
    eventListener = updateEvents;
    widget.controller.addListener(eventListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  // update day events when change
  void updateEvents() {
    if (mounted) {
      final weekEvents = getWeekEvents();
      final weekShowedEvents =
          getShowedWeekEvents(weekEvents, widget.maxEventsShowed);
      // no update if no change for current day
      if (!listEquals(weekShowedEvents, this.weekShowedEvents)) {
        setState(() {
          this.weekEvents = weekEvents;
          this.weekShowedEvents = weekShowedEvents;
        });
      }
    }
  }

  /// find events of week
  List<List<Event>?> getWeekEvents() {
    final eventsList = <List<Event>?>[];
    for (var day = 0; day < 7; day++) {
      eventsList.add(widget.controller.getSortedFilteredDayEvents(
        widget.startOfWeek.add(Duration(days: day)),
      ));
    }
    return eventsList;
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
      decoration: widget.weekParam.weekDecoration ??
          WeekParam.defaultWeekDecoration(context),
      child: SizedBox(
        height: widget.weekHeight,
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final dayWidth = width / 7;

          return DragTarget(
            onAcceptWithDetails: (details) {
              final onDragEnd = details.data! as Function(DateTime);
              final renderBox = context.findRenderObject()! as RenderBox;
              final relativeOffset = renderBox.globalToLocal(
                  Offset(details.offset.dx + dayWidth / 2, details.offset.dy));
              final dragDay = getPositionDay(relativeOffset, dayWidth);
              onDragEnd.call(dragDay);
            },
            builder: (context, candidateData, rejectedData) => GestureDetector(
                onTapDown: (details) => widget.daysParam.onDayTapDown
                    ?.call(getPositionDay(details.localPosition, dayWidth)),
                onTapUp: (details) => widget.daysParam.onDayTapUp
                    ?.call(getPositionDay(details.localPosition, dayWidth)),
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    // days header
                    SizedBox(
                      height: widget.daysParam.headerHeight,
                      child: Row(
                        children: [
                          for (var dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++)
                            Expanded(child: getHeaderWidget(dayOfWeek)),
                        ],
                      ),
                    ),

                    // week events
                    SizedBox(
                      height: widget.weekHeight - widget.daysParam.headerHeight,
                      child: Stack(
                        children: [
                          for (var dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++)
                            for (var eventIndex = 0;
                                eventIndex < weekShowedEvents[dayOfWeek].length;
                                eventIndex++)
                              if (eventIndex < widget.maxEventsShowed)
                                ...getEventOrMoreEventsWidget(
                                    dayOfWeek, eventIndex, dayWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          );
        }),
      ),
    );

  DateTime getPositionDay(Offset localPosition, double dayWidth) {
    final x = localPosition.dx;
    final dayIndex = (x / dayWidth).toInt();
    final day = widget.startOfWeek.add(Duration(days: dayIndex));
    return day;
  }

  // get header of day
  Widget getHeaderWidget(int dayOfWeek) {
    final day = widget.startOfWeek.add(Duration(days: dayOfWeek));
    final isStartOfMonth = day.day == 1;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: widget.daysParam.headerHeight,
      child: widget.daysParam.dayHeaderBuilder?.call(day) ??
          DefaultMonthDayHeader(
            text: isStartOfMonth
                ? '${defaultMonthAbrText[day.month - 1]} 1'
                : day.day.toString(),
            isToday: DateUtils.isSameDay(day, DateTime.now()),
            textColor:
                isStartOfMonth ? colorScheme.onSurface : colorScheme.outline,
          ),
    );
  }

  /// get Event widget or "More" widget
  List<Widget> getEventOrMoreEventsWidget(
    int dayOfWeek,
    int eventIndex,
    double dayWidth,
  ) {
    final daySpacing = widget.weekParam.daySpacing;
    final eventSpacing = widget.daysParam.eventSpacing;
    final eventHeight = widget.daysParam.eventHeight;
    final left = dayOfWeek * dayWidth + (daySpacing / 2);
    final eventsLength = weekEvents[dayOfWeek]?.length ?? 0;
    final day = widget.startOfWeek.add(Duration(days: dayOfWeek));

    // More widget
    final isLastSlot = eventIndex == widget.maxEventsShowed - 1;
    final notShowedEventsCount = (eventsLength - widget.maxEventsShowed) + 1;
    if (isLastSlot && notShowedEventsCount > 1) {
      return [
        Positioned(
          left: left,
          top: (widget.maxEventsShowed - 1) * (eventHeight + eventSpacing),
          width: dayWidth - daySpacing,
          height: eventHeight,
          child: widget.daysParam.dayMoreEventsBuilder
                  ?.call(notShowedEventsCount, day) ??
              DefaultNotShowedMonthEventsWidget(
                context: context,
                eventHeight: eventHeight,
                text: '$notShowedEventsCount others',
              ),
        )
      ];
    }

    // Event widget
    final event = weekShowedEvents[dayOfWeek][eventIndex];
    final isMultiDayOtherDay = (event?.daysIndex ?? 0) > 0 && dayOfWeek > 0;
    if (event != null && !isMultiDayOtherDay) {
      // multi days events duration
      var duration = 1;
      while (weekShowedEvents
              .getOrNull(dayOfWeek + duration)
              ?.getOrNull(eventIndex)
              ?.uniqueId ==
          event.uniqueId) {
        duration++;
      }
      final eventWidth = (dayWidth * duration) - daySpacing;
      final top = weekShowedEvents[dayOfWeek].indexOf(event) *
          (eventHeight + eventSpacing);
      return [
        Positioned(
            left: left,
            top: top,
            width: eventWidth,
            height: eventHeight,
            child: widget.daysParam.dayEventBuilder?.call(
                  event,
                  eventWidth,
                  eventHeight,
                ) ??
                DefaultMonthDayEvent(event: event))
      ];
    }

    return [];
  }
}
