import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

void main() {
  testWidgets('animates a laid-out day and jumps to an unbuilt day',
      (tester) async {
    final start = DateTime(2026, 10, 24);
    final events = EventsController();
    final listKey = GlobalKey<EventsListState>();
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: EventsList(
        key: listKey,
        controller: events,
        initialDate: start,
        dayHeaderBuilder: (day, _, __) =>
            SizedBox(key: ValueKey(day), height: 32),
        dayEventsBuilder: (day, _) =>
            SizedBox(height: day.day.isEven ? 120 : 210),
      ),
    ));
    await tester.pumpAndSettle();

    final state = listKey.currentState!;
    final later = start.addCalendarDays(2);
    final animation = state.animateToDate(
      later,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(state.mainVerticalController.offset,
        allOf(greaterThan(0), lessThan(394)));
    await tester.pumpAndSettle();
    await animation;
    expect(tester.getTopLeft(find.byKey(ValueKey(later))).dy, 0);
    expect(events.focusedDay, later);

    final far = start.addCalendarDays(100);
    expect(find.byKey(ValueKey(far)), findsNothing);
    final jump = state.animateToDate(far);
    await tester.pump();
    await jump;
    expect(tester.getTopLeft(find.byKey(ValueKey(far))).dy, 0);
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    events.dispose();
  });
}
