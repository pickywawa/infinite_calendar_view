import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:infinite_calendar_view/src/utils/event_helper.dart';

Event _buildEvent(String title, DateTime start, DateTime end) {
  return Event(
    title: title,
    startTime: start,
    endTime: end,
    isFullDay: true,
  );
}

void main() {
  test('fills free lanes and respects day list priority in visible slots', () {
    final controller = EventsController();
    controller.updateCalendarData((data) {
      data.addEvents([
        _buildEvent('Test 1', DateTime(2027, 8, 1), DateTime(2027, 8, 2, 23, 59)),
        _buildEvent('Test 2', DateTime(2027, 8, 3), DateTime(2027, 8, 3, 23, 59)),
        _buildEvent('Test 3', DateTime(2027, 8, 1), DateTime(2027, 8, 15, 23, 59)),
        _buildEvent('Test 4', DateTime(2027, 8, 1), DateTime(2027, 8, 15, 23, 59)),
        _buildEvent('Test 5', DateTime(2027, 8, 1), DateTime(2027, 8, 15, 23, 59)),
        _buildEvent('Test 6', DateTime(2027, 8, 1), DateTime(2027, 8, 15, 23, 59)),
      ]);
    });

    final startOfWeek = DateTime(2027, 8, 2);
    final weekEvents = List<List<Event>?>.generate(
      7,
      (day) => controller
          .getSortedFilteredDayEvents(startOfWeek.add(Duration(days: day))),
    );

    final showedEvents = getShowedWeekEvents(weekEvents, 3);

    // 2027-08-03 is day index 1 in this week.
    final day03 = showedEvents[1];
    expect(day03[0]?.title, 'Test 2');
    expect(day03[1]?.title, 'Test 3');
    expect(day03[2], isNull);

    // 2027-08-04 is day index 2 in this week.
    final day04 = showedEvents[2];
    expect(day04[0]?.title, 'Test 4');
    expect(day04[1]?.title, 'Test 3');
    expect(day04[2], isNull);
  });
}
