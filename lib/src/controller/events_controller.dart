import 'package:flutter/material.dart';

import '../events/event.dart';
import '../utils/extension.dart';

typedef EventFilter = List<Event>? Function(
    DateTime date, List<Event>? dayEvents);
typedef UpdateCalendarDataCallback = void Function(CalendarData calendarData);

class EventsController extends ChangeNotifier {
  EventsController();

  // events data
  final calendarData = CalendarData();

  // events filter to show on views
  EventFilter dayEventsFilter = (date, dayEvents) => dayEvents;

  // focused day : change when scroll on view
  var focusedDay = DateTime.now();

  // call when focused day change
  void Function(DateTime day)? onFocusedDayChange;

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

  void updateFocusedDay(DateTime day) {
    focusedDay = day;
    onFocusedDayChange?.call(day);
  }

  // get events for day with filter applied
  List<Event>? getFilteredDayEvents(
    DateTime date, {
    bool returnDayEvents = true,
    bool returnFullDayEvent = true,
    bool returnMultiDayEvents = true,
    bool returnMultiFullDayEvents = true,
  }) {
    final dayEvents = calendarData.dayEvents[date.withoutTime];
    final dayEventsByType = dayEvents
        ?.where((e) => e.isFullDay
            ? (e.isMultiDay ? returnMultiFullDayEvents : returnFullDayEvent)
            : (e.isMultiDay ? returnMultiDayEvents : returnDayEvents))
        .toList();
    return dayEventsFilter.call(date, dayEventsByType);
  }

  // get day events sorted by startTime
  List<Event>? getSortedFilteredDayEvents(DateTime date) {
    final daysEvents = getFilteredDayEvents(date);
    daysEvents?.sort((a, b) => a.startTime.compareTo(b.startTime));
    return daysEvents;
  }

  // force update UI
  @override
  void notifyListeners() => super.notifyListeners();
}

class CalendarData {
  final dayEvents = <DateTime, List<Event>>{};

  /// add all events and cuts up appointments if they are over several days
  void addEvents(List<Event> events) {
    for (final event in events) {
      final days = event.endTime?.withoutTime
              .difference(event.startTime.withoutTime)
              .inDays ??
          0;

      // if event is multi days, dispatch in all events days
      for (var i = 0; i <= days; i++) {
        final day = event.startTime.withoutTime.add(Duration(days: i));
        final startTime = i == 0 ? event.startTime : day;
        final endTime = (i == days && !event.isFullDay)
            ? event.endTime
            : day.add(const Duration(days: 1, milliseconds: -1));
        final newEvents = event.copyWith(
          startTime: startTime,
          endTime: endTime,
          effectiveStartTime: event.startTime,
          effectiveEndTime: event.endTime,
          daysIndex: days > 0 ? i : null,
        );
        _addDayEvent(day, newEvents);
      }
    }
  }

  // add day events
  void _addDayEvent(DateTime day, Event event) {
    final dayDate = day.withoutTime;
    if (!dayEvents.containsKey(dayDate)) {
      dayEvents[dayDate] = [];
    }
    dayEvents[dayDate]?.add(event);
  }

  /// replace all day events
  /// if eventType is entered, replace juste day event type
  /// not remove multi day event which start another day
  void replaceDayEvents(
    DateTime day,
    List<Event> events, [
    Object? eventType,
  ]) {
    removeDayEvents(day, eventType);
    addEvents(events);
  }

  /// update one event
  void updateEvent({required Event oldEvent, required Event newEvent}) {
    removeEvent(oldEvent);
    addEvents([newEvent]);
  }

  void moveEvent(Event event, DateTime newStartTime, [DateTime? newEndTime]) {
    updateEvent(
      oldEvent: event,
      newEvent: event.copyWith(
        startTime: newStartTime,
        endTime: event.endTime == null
            ? null
            : newEndTime ??
                newStartTime.add(event.getDuration() ?? Duration.zero),
      ),
    );
  }

  /// remove all event for day
  /// if eventType is entered, remove juste day event type
  /// does not delete multi-day events that do not start on that day
  void removeDayEvents(DateTime day, [Object? eventType]) {
    final eventsToRemove = dayEvents[day.withoutTime]?.where((e) =>
            (eventType == null || (e.eventType == eventType)) &&
            (!e.isMultiDay || e.daysIndex == 0)) ??
        [];
    for (final event in [...eventsToRemove]) {
      removeEvent(event.copyWith());
    }
  }

  /// remove event
  /// if event is multi days event, remove all occurrence for each day
  void removeEvent(Event event) {
    // remove multi days event
    if (event.isMultiDay) {
      removeMultiDayEvent(event);
    }
    // remove simple event or full day event
    else {
      dayEvents[event.startTime.withoutTime]
          ?.removeWhere((e) => e.uniqueId == event.uniqueId);
    }
  }

  /// remove multi day event
  /// remove all occurrence for each day
  void removeMultiDayEvent(Event event) {
    // remove event for event day and previous day for same event (multi day events)
    var previousDay = event.startTime.withoutTime;
    while (dayEvents[previousDay]?.any((e) => e.uniqueId == event.uniqueId) ??
        false) {
      dayEvents[previousDay]?.removeWhere((e) => e.uniqueId == event.uniqueId);
      previousDay = previousDay.subtract(const Duration(days: 1));
    }
    // remove next same event (multi day events)
    var nextDay = event.startTime.withoutTime.add(const Duration(days: 1));
    while (
        dayEvents[nextDay]?.any((e) => e.uniqueId == event.uniqueId) ?? false) {
      dayEvents[nextDay]?.removeWhere((e) => e.uniqueId == event.uniqueId);
      nextDay = nextDay.add(const Duration(days: 1));
    }
  }

  // clear all data
  void clearAll() {
    dayEvents.clear();
  }
}
