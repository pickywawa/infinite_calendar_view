import 'package:example/data2.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class Months2 extends StatefulWidget {
  const Months2({
    super.key,
  });

  @override
  State<Months2> createState() => _Months2State();
}

class _Months2State extends State<Months2> {
  var controller = EventsController()
    ..updateCalendarData((calendarData) {
      calendarData.addEvents(generateSampleEvents());
    });

  @override
  Widget build(BuildContext context) {
    return EventsMonths(
      controller: controller,
      weekParam: WeekParam(
        startOfWeekDay: 1, // start week on monday
        weekHeight: 100,
      ),
      daysParam: DaysParam(
        // custom builder : add drag and drop
        dayEventBuilder: (event, width, height) {
          return DraggableMonthEvent(
            child: DefaultMonthDayEvent(
              event: event.copyWith(
                color: event.color.pastel,
                textColor: event.textColor.onPastel,
              ),
              fullDayBorder: Border.all(width: 0, color: Colors.transparent),
            ),
            onDragEnd: (DateTime day) {
              controller.updateCalendarData((data) => move(data, event, day));
            },
          );
        },
        dayMoreEventsBuilder: (count, day) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showDayEventsPopup(day),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "+$count more",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  move(CalendarData data, Event event, DateTime newDay) {
    data.moveEvent(
      event,
      newDay.copyWith(
        hour: event.effectiveStartTime!.hour,
        minute: event.effectiveStartTime!.minute,
      ),
    );
  }

  Future<void> _showDayEventsPopup(DateTime day) async {
    final events = controller.getSortedFilteredDayEvents(day) ?? const <Event>[];

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Events ${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}',
          ),
          content: SizedBox(
            width: 320,
            child: events.isEmpty
                ? const Text('No event')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final title = event.title?.trim().isNotEmpty == true
                          ? event.title!
                          : 'Untitled event';
                      return Text(title, style: const TextStyle(fontSize: 13));
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
