import 'package:flutter/material.dart';
import '../../controller/events_controller.dart';
import '../../events_months.dart';
import '../../utils/extension.dart';
import 'week.dart';

class Month extends StatelessWidget {
  const Month({
    required this.controller,
    required this.month,
    required this.weekParam,
    required this.weekHeight,
    required this.daysParam,
    required this.maxEventsShowed,
    super.key,
  });

  final EventsController controller;
  final DateTime month;
  final WeekParam weekParam;
  final double weekHeight;
  final DaysParam daysParam;
  final int maxEventsShowed;

  @override
  Widget build(BuildContext context) {
    final startOfWeeks = <DateTime>[];
    var startOfWeek = month.startOfWeek(weekParam.startOfWeekDay);
    while (startOfWeek.add(const Duration(days: 6)).month == month.month) {
      startOfWeeks.add(startOfWeek);
      startOfWeek = startOfWeek.add(const Duration(days: 7));
    }

    // weeks of month
    return Column(
      children: [
        for (final startOfWeek in startOfWeeks)
          Week(
            controller: controller,
            weekParam: weekParam,
            weekHeight: weekHeight,
            daysParam: daysParam,
            startOfWeek: startOfWeek,
            maxEventsShowed: maxEventsShowed,
          )
      ],
    );
  }
}
