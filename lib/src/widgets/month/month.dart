import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/controller/events_controller.dart';
import 'package:infinite_calendar_view/src/events_months.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';
import 'package:infinite_calendar_view/src/widgets/month/week.dart';

class Month extends StatelessWidget {
  const Month({
    super.key,
    required this.controller,
    required this.month,
    required this.weekParam,
    required this.daysParam,
  });

  final EventsController controller;
  final DateTime month;
  final WeekParam weekParam;
  final DaysParam daysParam;

  @override
  Widget build(BuildContext context) {
    var startOfWeeks = <DateTime>[];
    var startOfWeek = month.startOfWeek(weekParam.startOfWeekDay);
    while (startOfWeek.add(Duration(days: 6)).month == month.month) {
      startOfWeeks.add(startOfWeek);
      startOfWeek = startOfWeek.add(Duration(days: 7));
    }

    // weeks of month
    return Column(
      children: [
        for (var startOfWeek in startOfWeeks)
          Week(
            controller: controller,
            weekParam: weekParam,
            daysParam: daysParam,
            startOfWeek: startOfWeek,
          )
      ],
    );
  }
}