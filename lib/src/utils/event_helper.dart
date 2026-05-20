import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/events/event.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';

/// Builds a 7 x `maxEventsShowed` display grid for one week.
///
/// Strategy:
/// 1) Place multi-day events first so they keep a stable row (lane) across days.
/// 2) Fill remaining holes per day with single-day events.
List<List<Event?>> getShowedWeekEvents(
  List<List<Event>?> weekEvents,
  int maxEventsShowed,
) {
  final daysEventsList =
      List.generate(7, (_) => List<Event?>.filled(maxEventsShowed, null));
  if (maxEventsShowed <= 0) return daysEventsList;

  final segments = _buildSortedMultiDaySegments(weekEvents);
  final laneBySegmentId = _assignMultiDayLanes(segments);

  // Multi-day events are written first to reserve stable visual lanes.
  // If a lane is outside the visible cap, the event is hidden and counted by UI as "other".
  for (final segment in segments) {
    final lane = laneBySegmentId[segment.uniqueId]!;
    if (lane >= maxEventsShowed) continue;
    for (final entry in segment.eventsByDay.entries) {
      daysEventsList[entry.key][lane] = entry.value;
    }
  }

  // Single-day events are only allowed to fill holes left by multi-day placement.
  // This avoids pushing a multi-day event to a different lane on adjacent days.
  for (var day = 0; day < 7; day++) {
    final dayEvents = weekEvents[day] ?? const <Event>[];
    final singleDayEvents = dayEvents.where((e) => !e.isMultiDay);
    for (final event in singleDayEvents) {
      final emptyLane = daysEventsList[day].indexOf(null);
      if (emptyLane == -1) break;
      daysEventsList[day][emptyLane] = event;
    }
  }

  return daysEventsList;
}

List<_MultiDaySegment> _buildSortedMultiDaySegments(
    List<List<Event>?> weekEvents) {
  final multiDaysEventsMap = <UniqueKey, Map<int, Event>>{};
  final insertionOrder = <UniqueKey, int>{};
  var orderCounter = 0;

  for (var day = 0; day < 7; day++) {
    final multiDaysEvents = weekEvents[day]?.where((e) => e.isMultiDay);
    for (final event in multiDaysEvents ?? const <Event>[]) {
      // Keep the first-seen position as a final deterministic tie-breaker.
      // This preserves input order when start day/time and duration are identical.
      if (!insertionOrder.containsKey(event.uniqueId)) {
        insertionOrder[event.uniqueId] = orderCounter++;
      }
      multiDaysEventsMap[event.uniqueId] = {
        ...multiDaysEventsMap[event.uniqueId] ?? {},
        day: event,
      };
    }
  }

  final segments = multiDaysEventsMap.entries
      .map((entry) => _MultiDaySegment(
            uniqueId: entry.key,
            eventsByDay: entry.value,
            insertionOrder: insertionOrder[entry.key]!,
          ))
      .toList();

  segments.sort((a, b) {
    // Sort priority for multi-day placement:
    // - earlier visible start day first
    // - then original input order (list priority)
    // - then earlier start time
    // - then longer spans first (so long bars claim lanes early)
    final compareStartDay = a.startDay.compareTo(b.startDay);
    if (compareStartDay != 0) return compareStartDay;

    final compareInsertion = a.insertionOrder.compareTo(b.insertionOrder);
    if (compareInsertion != 0) return compareInsertion;

    final compareStartTime = a.startTime.compareTo(b.startTime);
    if (compareStartTime != 0) return compareStartTime;

    return b.durationDays.compareTo(a.durationDays);
  });

  return segments;
}

Map<UniqueKey, int> _assignMultiDayLanes(List<_MultiDaySegment> segments) {
  final laneBySegmentId = <UniqueKey, int>{};
  final occupiedDaysByLane = <Set<int>>[];

  for (final segment in segments) {
    var lane = 0;
    while (true) {
      if (lane == occupiedDaysByLane.length) {
        occupiedDaysByLane.add(<int>{});
      }

      final occupiedDays = occupiedDaysByLane[lane];
      // Greedy first-fit: choose the first lane that does not overlap
      // any day covered by this segment.
      final overlap = segment.days.any(occupiedDays.contains);
      if (!overlap) {
        occupiedDays.addAll(segment.days);
        laneBySegmentId[segment.uniqueId] = lane;
        break;
      }

      lane++;
    }
  }

  return laneBySegmentId;
}

class _MultiDaySegment {
  _MultiDaySegment({
    required this.uniqueId,
    required this.eventsByDay,
    required this.insertionOrder,
  });

  final UniqueKey uniqueId;
  final Map<int, Event> eventsByDay;
  final int insertionOrder;

  // Days are normalized to week indexes (0..6), not absolute calendar days.
  List<int> get days => eventsByDay.keys.toList()..sort();

  int get startDay => days.first;

  int get endDay => days.last;

  int get durationDays => (endDay - startDay) + 1;

  DateTime get startTime => eventsByDay[startDay]!.startTime;
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.addCalendarDays(i));
  }
  return days;
}
