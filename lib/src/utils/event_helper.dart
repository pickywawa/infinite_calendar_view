import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/events/event.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';

/// Builds a 7 x `maxEventsShowed` display grid for one week.
///
/// Strategy:
/// 1) Keep continued visible multi-day events on the same lane.
/// 2) Fill remaining visible lanes using the day's sorted event order.
List<List<Event?>> getShowedWeekEvents(
  List<List<Event>?> weekEvents,
  int maxEventsShowed,
) {
  final daysEventsList =
      List.generate(7, (_) => List<Event?>.filled(maxEventsShowed, null));
  if (maxEventsShowed <= 0) return daysEventsList;

  final segments = _buildSortedMultiDaySegments(weekEvents);
  final segmentById = {for (final segment in segments) segment.uniqueId: segment};

  // Place multi-day events day-by-day:
  // - keep lane continuity for events already visible the previous day,
  // - then fill remaining holes with other active multi-day events.
  final previousVisibleIds = List<UniqueKey?>.filled(maxEventsShowed, null);
  final firstVisibleDayById = <UniqueKey, int>{};
  for (var day = 0; day < 7; day++) {
    final dayLaneEvents = List<Event?>.filled(maxEventsShowed, null);
    final placedIds = <UniqueKey>{};
    final dayEvents = weekEvents[day] ?? const <Event>[];
    final dayEventsCount = weekEvents[day]?.length ?? 0;
    final dayVisibleLaneCount =
        dayEventsCount > maxEventsShowed ? maxEventsShowed - 1 : maxEventsShowed;

    // 1) Preserve lane continuity for already visible multi-day events.
    for (var lane = 0; lane < dayVisibleLaneCount; lane++) {
      final previousId = previousVisibleIds[lane];
      if (previousId == null) continue;

      final continuingSegment = segmentById[previousId];
      if (continuingSegment == null ||
          !continuingSegment.eventsByDay.containsKey(day)) {
        continue;
      }

      dayLaneEvents[lane] = continuingSegment.eventsByDay[day];
      placedIds.add(continuingSegment.uniqueId);
      firstVisibleDayById.putIfAbsent(continuingSegment.uniqueId, () => day);
    }

    // 2) Fill remaining visible lanes in day order (list priority).
    for (final dayEvent in dayEvents) {
      if (dayEvent.isMultiDay && placedIds.contains(dayEvent.uniqueId)) {
        continue;
      }

      final emptyLane = _findFirstEmptyLane(dayLaneEvents, dayVisibleLaneCount);
      if (emptyLane == -1) break;

      var event = dayEvent;

      // If this event becomes visible for the first time mid-week,
      // mark that day as a local segment start so it can be rendered.
      if (event.isMultiDay) {
        final firstVisibleDay = firstVisibleDayById[event.uniqueId];
        if (firstVisibleDay == null) {
          firstVisibleDayById[event.uniqueId] = day;
          if (day > 0 && (event.daysIndex ?? 0) > 0) {
            event = event.copyWith(daysIndex: 0);
          }
        }
      }

      dayLaneEvents[emptyLane] = event;
      if (event.isMultiDay) {
        placedIds.add(event.uniqueId);
      }
    }

    daysEventsList[day] = dayLaneEvents;

    for (var lane = 0; lane < maxEventsShowed; lane++) {
      previousVisibleIds[lane] = dayLaneEvents[lane]?.uniqueId;
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

int _findFirstEmptyLane(List<Event?> lanes, int limit) {
  for (var i = 0; i < limit; i++) {
    if (lanes[i] == null) return i;
  }
  return -1;
}
