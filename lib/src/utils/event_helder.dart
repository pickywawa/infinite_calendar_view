import 'dart:collection';

import 'package:flutter/material.dart';
import '../events/event.dart';
import 'extension.dart';

/// find event must be showed, and place multi day event in same row
List<List<Event?>> getShowedWeekEvents(
  List<List<Event>?> weekEvents,
  int maxEventsShowed,
) {
  final sortedMultiDayEvents = getWeekMultiDaysEventsSortedMap(weekEvents);

  // place no multi days events to show
  final daysEventsList = List<List<Event?>>.generate(7, (index) {
    final events = (weekEvents[index] ?? []).where((e) => !e.isMultiDay);
    return List.generate(maxEventsShowed, events.getOrNull);
  });

  for (final multiDayEvents in sortedMultiDayEvents.values) {
    final dayPlacedEvents = daysEventsList[multiDayEvents.keys.first];
    final eventToPlace = multiDayEvents.values.first;
    var index = 0;
    // compute index to place line
    while (index < dayPlacedEvents.length && dayPlacedEvents[index] != null) {
      final placedEvent = dayPlacedEvents[index]!;
      if (eventToPlace.startTime.millisecondsSinceEpoch >
          placedEvent.startTime.millisecondsSinceEpoch) {
        index++;
      } else {
        break;
      }
    }

    // place all line
    if (index < maxEventsShowed) {
      for (final eventToPlace in multiDayEvents.entries) {
        daysEventsList[eventToPlace.key].insert(index, eventToPlace.value);
      }
    }
  }
  return daysEventsList;
}

// generate sorted map of all multi days events on week
SplayTreeMap<UniqueKey, Map<int, Event>> getWeekMultiDaysEventsSortedMap(
    List<List<Event>?> weekEvents) {
  // generate map of all multi days events
  final multiDaysEventsMap = <UniqueKey, Map<int, Event>>{};
  for (var day = 0; day < 7; day++) {
    final multiDaysEvents = weekEvents[day]?.where((e) => e.isMultiDay);
    if (multiDaysEvents?.isEmpty ?? true) continue;
    for (final event in multiDaysEvents!) {
      multiDaysEventsMap[event.uniqueId] = {
        ...multiDaysEventsMap[event.uniqueId] ?? {},
        day: event
      };
    }
  }

  // sort multi days events
  final sortedMultiDayEvents = SplayTreeMap<UniqueKey, Map<int, Event>>.from(
    multiDaysEventsMap,
    (a, b) {
      final eventA = multiDaysEventsMap[a]!.values.first;
      final eventB = multiDaysEventsMap[b]!.values.first;
      return eventA.startTime.compareTo(
        eventB.startTime,
      );
    },
  );

  return sortedMultiDayEvents;
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  final days = <DateTime>[];
  for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}
