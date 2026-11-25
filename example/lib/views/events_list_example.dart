import 'package:example/app.dart';
import 'package:example/views/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({
    super.key,
  });

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  GlobalKey<EventsListState> listViewKey = GlobalKey<EventsListState>();
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = eventsController.focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8.0),
        buildCalendar(),
        const SizedBox(height: 4.0),
        Divider(color: Theme.of(context).colorScheme.outlineVariant, height: 2),
        Expanded(
          child: EventsList(
            key: listViewKey,
            controller: eventsController,
            dayEventsBuilder: (day, events) {
              return DefaultDayEvents(
                events: events,
                nullEventsWidget: DefaultDayEvents.defaultEmptyEventsWidget,
                eventBuilder: (event) => DefaultDetailEvent(event: event),
              );
            },
            onDayChange: (firstDay) {
              setState(() {
                selectedDay = firstDay;
              });
            },
            dayHeaderBuilder: (day, isToday, events) => DefaultHeader(
              dayText: DateFormat.MMMMEEEEd().format(day).toUpperCase(),
            ),
          ),
        ),
      ],
    );
  }

  Calendar buildCalendar() {
    return Calendar(
      selectedDay: selectedDay,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
        });
        eventsController.updateFocusedDay(selectedDay);
        listViewKey.currentState?.animateToDate(selectedDay);
      },
    );
  }
}
