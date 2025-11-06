import 'package:example/views/events_months_example.dart';
import 'package:example/views/events_months_rtl_example.dart';
import 'package:example/views/events_planner_multi_columns2_example.dart';
import 'package:example/views/events_planner_multi_columns_example.dart';
import 'package:example/views/events_planner_one_day_example.dart';
import 'package:example/views/events_planner_rotate_example.dart';
import 'package:example/views/events_planner_rotate_multi_columns_example.dart';
import 'package:example/views/events_planner_rtl_example.dart';
import 'package:example/views/events_planner_three_days_example.dart';
import 'package:example/views/events_planner_three_days_example2.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_bar.dart';
import 'data.dart';
import 'enumerations.dart';
import 'views/events_list_example.dart';
import 'views/events_planner_draggable_events_example.dart';
import 'views/events_timeline_example.dart';

var isDarkMode = false;
var calendarMode = Mode.day3Draggable;
var eventsController = EventsController();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting("ar_TN");
    eventsController.updateCalendarData((calendarData) {
      calendarData.addEvents(events);
      calendarData.addEvents(fullDayEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Calendar View',
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: switch (calendarMode) {
              Mode.day7 => double.infinity,
              Mode.day3Rotation => 1000,
              Mode.day3RotationMultiColumn => 1000,
              _ => 500,
            },
            maxHeight: switch (calendarMode) {
              _ => double.infinity,
            },
          ),
          child: Scaffold(
            appBar: CustomAppBar(
              eventsController: eventsController,
              onChangeCalendarView: (newCalendarMode) {
                setState(() => calendarMode = newCalendarMode);
              },
              onChangeDarkMode: (darkMode) {
                setState(() => isDarkMode = darkMode);
              },
            ),
            body: CalendarViewWidget(),
          ),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(backgroundColor: Color(0xff2F2F2F)),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Colors.blueAccent,
      ),
    );
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.blue,
        primary: Colors.blue,
      ),
    );
  }
}

class CalendarViewWidget extends StatelessWidget {
  const CalendarViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (calendarMode) {
      Mode.agenda => EventsListView(),
      Mode.day => PlannerOneDay(key: UniqueKey()),
      Mode.day3 => PlannerTreeDays(key: UniqueKey()),
      Mode.day3Draggable => PlannerEventsDrag(key: UniqueKey(), daysShowed: 3),
      Mode.day3Slot => PlannerTreeDaysSlot(key: UniqueKey()),
      Mode.day7 => PlannerEventsDrag(key: UniqueKey(), daysShowed: 7),
      Mode.multiColumn => PlannerMultiColumns(key: UniqueKey()),
      Mode.multiColumn2 => PlannerMultiColumns2(key: UniqueKey()),
      Mode.month => Months(key: UniqueKey()),
      Mode.day3RTL => PlannerRTL(key: UniqueKey()),
      Mode.monthRTL => MonthsRTL(key: UniqueKey()),
      Mode.day3Rotation => PlannerRotation(key: UniqueKey()),
      Mode.day3RotationMultiColumn =>
        PlannerRotateMultiColumns(key: UniqueKey()),
    };
  }
}
