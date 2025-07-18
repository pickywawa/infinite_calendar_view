import 'package:flutter/material.dart';

const defaultType = 'default';

class Event {
  Event({
    required this.startTime, this.columnIndex = 0,
    this.endTime,
    this.isFullDay = false,
    this.title,
    this.description,
    this.data,
    this.eventType = defaultType,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.daysIndex,
  }) {
    if (!isFullDay) {
      assert(endTime != null, 'endTime cannot be null for non full day event');
    }
    if (endTime != null) {
      assert(endTime!.isAfter(startTime), 'endTime must be after startTime');
    }
  }

  // generated unique id
  late var uniqueId = UniqueKey();

  // column index in planner mode, 0 if not multiple column
  final int columnIndex;

  // event start time.
  // for full day event, set start of day
  final DateTime startTime;

  // event end time.
  // for full day event, set null
  // for multi days event, set dateTime of other day
  final DateTime? endTime;

  // full day event
  final bool isFullDay;

  // title showed in default event widget (can be overridden)
  final String? title;

  // description showed in default event widget (can be overridden)
  final String? description;

  // background color showed in default event widget (can be overridden)
  final Color color;

  // text color showed in default event widget (can be overridden)
  final Color textColor;

  // transported data for event
  final Object? data;

  // event type : generic object to easy manipulate event (arranger, widget...)
  final Object eventType;

  // multi days index
  final int? daysIndex;

  // effective start time for multi days events (startTime is for one day)
  DateTime? effectiveStartTime;

  // effective end time for multi days events (end is for one day)
  DateTime? effectiveEndTime;

  bool get isMultiDay => daysIndex != null;

  Event copyWith({
    int? columnIndex,
    DateTime? startTime,
    DateTime? endTime,
    bool? isFullDay,
    String? title,
    String? description,
    Color? color,
    Color? textColor,
    Object? data,
    Object? eventType,
    int? daysIndex,
    DateTime? effectiveStartTime,
    DateTime? effectiveEndTime,
  }) {
    final event = Event(
      columnIndex: columnIndex ?? this.columnIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isFullDay: isFullDay ?? this.isFullDay,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      data: data ?? this.data,
      eventType: eventType ?? this.eventType,
      daysIndex: daysIndex ?? this.daysIndex,
    )
    ..uniqueId = uniqueId
    ..effectiveStartTime = effectiveStartTime ?? this.effectiveStartTime
    ..effectiveEndTime = effectiveEndTime ?? this.effectiveEndTime;
    return event;
  }

  Duration? getDuration() {
    if (effectiveStartTime != null && effectiveEndTime != null) {
      return effectiveEndTime!.difference(effectiveStartTime!);
    }
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }
}
