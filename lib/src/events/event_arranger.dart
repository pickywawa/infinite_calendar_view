import 'event.dart';

// Coupled
//ignore: one_member_abstracts
abstract class EventArranger {
  /// [EventArranger] defines how simultaneous events will be arranged.
  /// Implement [arrange] method to define how events will be arranged.
  ///
  /// There are three predefined class that implements of [EventArranger].
  ///
  const EventArranger();

  List<OrganizedEvent> arrange({
    required List<Event> events,
    required double height,
    required double width,
    required double heightPerMinute,
  });
}

/// Provides event data with its [left], [right], [top], and [bottom] boundary.
class OrganizedEvent {
  /// Provides event data with its [left], [right], [top], and [bottom]
  /// boundary.
  OrganizedEvent({
    required this.startDuration,
    required this.endDuration,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.event,
  });

  /// Top position from where event tile will start.
  final double top;

  /// End position from where event tile will end.
  final double bottom;

  /// Left position from where event tile will start.
  final double left;

  /// Right position where event tile will end.
  final double right;

  /// Event to display in given tile.
  final Event event;

  /// Start duration of event/event list.
  final DateTime startDuration;

  /// End duration of event/event list.
  final DateTime endDuration;

  OrganizedEvent getWithUpdatedRight(double right) => OrganizedEvent(
        top: top,
        bottom: bottom,
        endDuration: endDuration,
        event: event,
        left: left,
        right: right,
        startDuration: startDuration,
      );
}
