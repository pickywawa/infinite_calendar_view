import 'package:flutter/material.dart';

import '../events/event.dart';
import '../extension.dart';

typedef EventFilter = List<Event>? Function(
    DateTime date, List<Event>? dayEvents);
typedef FullDayEventFilter = List<FullDayEvent>? Function(
    DateTime date, List<FullDayEvent>? dayEvents);
typedef UpdateCalendarDataCallback = void Function(CalendarData calendarData);

class EventsController extends ChangeNotifier {
  EventsController({EventFilter? eventFilter});

  final CalendarData calendarData = CalendarData();

  EventFilter dayEventsFilter = (date, dayEvents) => dayEvents;
  FullDayEventFilter fullDayEventsFilter = (date, dayEvents) => dayEvents;

  /// modify event data and update UI
  void updateCalendarData(UpdateCalendarDataCallback fn) {
    fn.call(calendarData);
    notifyListeners();
  }

  // change day event filter and update UI
  void updateDayEventsFilter({required EventFilter newFilter}) {
    dayEventsFilter = newFilter;
    notifyListeners();
  }

  // change full day event filter and update UI
  void updateFullDayEventsFilter({required FullDayEventFilter newFilter}) {
    fullDayEventsFilter = newFilter;
    notifyListeners();
  }

  // get event for day with filter applied
  List<Event>? getFilteredDayEvents(DateTime date) {
    return dayEventsFilter.call(date, calendarData.dayEvents[date.withoutTime]);
  }

  // get full day event for day with filter applied
  List<FullDayEvent>? getFilteredFullDayEvents(DateTime date) {
    return fullDayEventsFilter.call(
        date, calendarData.fullDayEvents[date.withoutTime]);
  }

  // force update UI
  @override
  void notifyListeners() => super.notifyListeners();
}

class CalendarData {
  final dayEvents = <DateTime, List<Event>>{};
  final fullDayEvents = <DateTime, List<FullDayEvent>>{};

  void addEvents(List<Event> events) {
    final dayMaxDuration = Duration(days: 1) - Duration(microseconds: 1);

    for (var event in events) {
      var currentDayStartTime = event.startTime.withoutTime;
      var currentDayEventShouldStartAt = event.startTime;

      while (currentDayEventShouldStartAt.isBefore(event.endTime)) {
        final currentDayEndTime = currentDayStartTime.add(dayMaxDuration);
        final currentDayEventShouldEndAt = event.endTime.isBefore(currentDayEndTime)
            ? event.endTime
            : currentDayEndTime;

        addDayEvents(currentDayStartTime, [
          event.copyWith(
              startTime: currentDayEventShouldStartAt,
              endTime: currentDayEventShouldEndAt)
        ]);

        currentDayStartTime = currentDayStartTime.add(Duration(days: 1));
        currentDayEventShouldStartAt = currentDayStartTime;
      }
    }
  }

  // add day events
  void addDayEvents(DateTime day, List<Event> events) {
    var dayDate = day.withoutTime;
    if (!dayEvents.containsKey(dayDate)) {
      dayEvents[dayDate] = [];
    }
    dayEvents[dayDate] = [...dayEvents[dayDate]!, ...events];
  }

  /// add full day event
  void addFullDayEvents(DateTime day, List<FullDayEvent> events) {
    var dayDate = day.withoutTime;
    if (!fullDayEvents.containsKey(dayDate)) {
      fullDayEvents[dayDate] = [];
    }
    fullDayEvents[dayDate] = [...fullDayEvents[dayDate]!, ...events];
  }

  /// replace all day events
  /// if eventType is entered, replace juste day event type
  void replaceDayEvents(DateTime day, List<Event> events,
      {final Object? eventType}) {
    if (eventType != null) {
      dayEvents[day.withoutTime]?.removeWhere((e) => e.eventType == eventType);
    } else {
      dayEvents[day.withoutTime]?.clear();
    }
    addDayEvents(day, events);
  }

  /// update one event
  void updateEvent({required Event oldEvent, required Event newEvent}) {
    var oldDayDate = oldEvent.startTime.withoutTime;
    var newDayDate = newEvent.startTime.withoutTime;
    dayEvents[oldDayDate]?.remove(oldEvent);
    addDayEvents(newDayDate, [newEvent]);
  }

  // clear all data
  clearAll() {
    dayEvents.clear();
    fullDayEvents.clear();
  }
}
