import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart' as intl;

import '../app.dart';
import '../data.dart';

class PlannerTreeDaysWidthRatio extends StatefulWidget {
  const PlannerTreeDaysWidthRatio({
    super.key,
  });

  @override
  State<PlannerTreeDaysWidthRatio> createState() =>
      _PlannerTreeDaysWidthRatioState();
}

class _PlannerTreeDaysWidthRatioState extends State<PlannerTreeDaysWidthRatio> {
  final EventsController controller = EventsController();
  final TextEditingController _titleController = TextEditingController();
  PersistentBottomSheetController? _bottomSheetController = null;

  @override
  void initState() {
    super.initState();
    controller.updateCalendarData((calendarData) {
      calendarData.addEvents(reservationsEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.0;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: eventsController,
      daysShowed: 3,
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      onAutomaticAdjustHorizontalScroll: (day) =>
          print("onAutomaticAdjustHorizontalScroll: $day"),
      onDayChange: (firstDay) => print("onDayChange: $firstDay"),
      dayWidthBuilder: (day, defaultWidth) {
        return switch (day.weekday) {
          DateTime.saturday || DateTime.sunday => defaultWidth * 0.5,
          _ when DateUtils.isSameDay(day, DateTime.now()) => defaultWidth * 2,
          _ => defaultWidth
        };
      },
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: true,
        dayHeaderTextBuilder: (day) => intl.DateFormat("E d").format(day),
      ),
    );
  }
}
