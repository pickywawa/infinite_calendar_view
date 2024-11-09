import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

class EventsPlannerView extends StatelessWidget {
  const EventsPlannerView({
    super.key,
    required this.controller,
    required this.daysShowed,
    required this.isDarkMode,
  });

  final EventsController controller;
  final int daysShowed;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: controller,
      daysShowed: daysShowed,
      initialDate: DateTime.now(),
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: daysShowed != 1,
        daysHeaderColor: Theme.of(context).appBarTheme.backgroundColor,
        dayHeaderBuilder: (day, isToday) {
          return DefaultDayHeader(
            dayText: DateFormat("E d").format(day),
            isToday: isToday,
            foregroundColor:
                isDarkMode ? Theme.of(context).colorScheme.primary : null,
          );
        },
      ),
      dayParam: DayParam(
        onSlotTap: (exactDateTime, roundDateTime) {},
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return draggableEvent(event, height, width, heightPerMinute);
        },
      ),
    );
  }

  DraggableEventWidget draggableEvent(
    Event event,
    double height,
    double width,
    double heightPerMinute,
  ) {
    return DraggableEventWidget(
      event: event,
      height: height,
      width: width,
      heightPerMinute: heightPerMinute,
      onDragEnd: (
        exactStartDateTime,
        exactEndDateTime,
        roundStartDateTime,
        roundEndDateTime,
      ) {
        moveEvent(event, roundStartDateTime, roundEndDateTime);
      },
      child: DefaultDayEvent(
        height: height,
        width: width,
        title: event.title,
        description: event.description,
        color: isDarkMode ? event.color.onPastel : event.color,
        textColor: isDarkMode ? event.textColor.pastel : event.textColor,
      ),
    );
  }

  void moveEvent(
    Event oldEvent,
    DateTime roundStartDateTime,
    DateTime roundEndDateTime,
  ) {
    controller.updateCalendarData((calendarData) {
      calendarData.updateEvent(
        oldEvent: oldEvent,
        newEvent: oldEvent.copyWith(
          startTime: roundStartDateTime,
          endTime: roundEndDateTime,
        ),
      );
    });
  }
}