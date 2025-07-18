import '../utils/extension.dart';
import 'event.dart';
import 'event_arranger.dart';

class SideEventArranger extends EventArranger {
  const SideEventArranger({
    this.paddingLeft = 0,
    this.paddingRight = 0,
  });

  final double paddingLeft;
  final double paddingRight;

  @override
  List<OrganizedEvent> arrange({
    required List<Event> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    final eventsConflict = <Event, List<Event>>{};
    final eventsConflictGroup = <Event, Set<Event>>{};

    // determine conflict to each event
    for (final event in events) {
      final conflicts = events
          .where((e) =>
              e != event &&
              e.startTime.isBefore(event.endTime!) &&
              e.endTime!.isAfter(event.startTime))
          .toList();
      eventsConflict[event] = conflicts;

      // complete conflict groups
      if (eventsConflictGroup[event] == null) {
        eventsConflictGroup[event] = {};
      }
      eventsConflictGroup[event]?.addAll(conflicts.toSet());
      for (final conflictEvent in conflicts) {
        if (eventsConflictGroup[conflictEvent] == null) {
          eventsConflictGroup[conflictEvent] = {};
        }
        eventsConflictGroup[conflictEvent]?.addAll(eventsConflictGroup[event]!);
      }
    }

    final eventsColumn = <Event, int>{};
    for (final eventEntry in eventsConflict.entries) {
      // no conflict
      if (eventEntry.value.isEmpty) {
        eventsColumn[eventEntry.key] = 0;
      }
      // conflicts : search free column (no already planned)
      else {
        final alreadyPlacedColumn = eventEntry.value
            .map((c) => eventsColumn[c])
            .where((e) => e != null)
            .toSet();
        var column = 0;
        while (alreadyPlacedColumn.contains(column)) {
          column++;
        }
        eventsColumn[eventEntry.key] = column;
      }
    }

    final organizedEvents = events.map((event) {
      final columnIndex = eventsColumn[event]!;

      // count column conflict for event
      // bug : no just see conflict of conflict event -> see recursive
      final columnSet = eventsConflictGroup[event]!
          .map((c) => eventsColumn[c])
          .where((e) => e != null)
          .toSet()
          .where((e) => e != null)
          .toSet();
      columnSet.add(columnIndex);
      final maxColumn = columnSet.length;

      // determine column width
      final widthWithPadding = width - (paddingLeft + paddingRight);
      final columnWidth = widthWithPadding / maxColumn;

      return OrganizedEvent(
        top: event.startTime.totalMinutes * heightPerMinute,
        bottom: height - (event.endTime!.totalMinutes * heightPerMinute),
        left: (columnIndex * columnWidth) + paddingLeft,
        right: ((maxColumn - columnIndex - 1) * columnWidth) + paddingRight,
        startDuration: event.startTime,
        endDuration: event.endTime!,
        event: event,
      );
    }).toList();
    return organizedEvents;
  }
}
