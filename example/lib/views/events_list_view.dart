import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class EventsListView extends StatelessWidget {
  const EventsListView({
    super.key,
    required this.controller,
  });

  final EventsController controller;

  @override
  Widget build(BuildContext context) {
    return EventsList(
      controller: controller,
      dayEventsBuilder: (day, events) {
        return DefaultDayEvents(
          events: events,
          nullEventsWidget: DefaultDayEvents.defaultEmptyEventsWidget,
          eventBuilder: (event) => DefaultDetailEvent(event: event),
        );
      },
      dayHeaderBuilder: (day, isToday, events) => DefaultHeader(
        dayText: DateFormat.MMMMEEEEd().format(day).toUpperCase(),
      ),
    );
  }
}
