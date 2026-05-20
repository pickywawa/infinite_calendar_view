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
        dayMoreEventsBuilder: (count, day) => Text(
          "+$count more",
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 10,
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
}
