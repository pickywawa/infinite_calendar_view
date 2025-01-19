import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import 'controller/events_controller.dart';
import 'events/event.dart';
import 'utils/extension.dart';
import 'widgets/details/day_details.dart';
import 'widgets/details/header_details.dart';

class EventsList extends StatefulWidget {
  const EventsList({
    super.key,
    required this.controller,
    this.initialDate,
    this.maxPreviousDays = 365,
    this.maxNextDays = 365,
    this.todayHeaderColor = const Color(0xFFf4f9fd),
    this.dayHeaderBuilder,
    this.onDayChange,
    this.dayEventsBuilder,
    this.verticalScrollPhysics = const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.fast,
    ),
    this.showWebScrollBar = false,
  });

  /// data controller
  final EventsController controller;

  /// initial first day
  final DateTime? initialDate;

  /// max horizontal previous days scroll
  /// Null for infinite
  final int? maxPreviousDays;

  /// max horizontal next days scroll
  /// Null for infinite
  final int? maxNextDays;

  /// events builder
  /// for listening event tap, it's possible to add gesture detector to dayEventsBuilder
  /// for loading widget, set day events to empty when day events are loaded
  /// null -> loading in progress (return shimmer or loader)
  /// empty -> no events on day (return text)
  final Widget Function(DateTime day, List<Event>? events)? dayEventsBuilder;

  /// Callback when day change during vertical scroll
  final void Function(DateTime day)? onDayChange;

  /// today day color
  /// null for no color
  final Color? todayHeaderColor;

  /// show scroll bar for web
  final bool showWebScrollBar;

  /// day builder in top bar
  final Widget Function(
    DateTime day,
    bool isToday,
    List<Event>? events,
  )? dayHeaderBuilder;

  /// Vertical day scroll physics
  final ScrollPhysics verticalScrollPhysics;

  @override
  State createState() => EventsListState();
}

class EventsListState extends State<EventsList> {
  late ScrollController mainVerticalController;
  late DateTime initialDay;
  late DateTime stickyDay;
  bool listenScroll = true;

  @override
  void initState() {
    super.initState();
    initialDay =
        widget.initialDate?.withoutTime ?? widget.controller.focusedDay;
    stickyDay = initialDay;
    mainVerticalController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: widget.showWebScrollBar,
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      child: InfiniteList(
        controller: mainVerticalController,
        direction: InfiniteListDirection.multi,
        negChildCount: widget.maxPreviousDays,
        posChildCount: widget.maxNextDays,
        physics: widget.verticalScrollPhysics,
        builder: (context, index) {
          var day = initialDay.add(Duration(days: index)).withoutTime;
          var isToday = DateUtils.isSameDay(day, DateTime.now());

          return InfiniteListItem(
            headerStateBuilder: (context, state) {
              if (state.sticky && listenScroll) {
                if (stickyDay != day) {
                  stickyDay = day;
                  Future(() {
                    widget.onDayChange?.call(stickyDay);
                    widget.controller.updateFocusedDay(stickyDay);
                  });
                }
              }
              return HeaderListWidget(
                controller: widget.controller,
                day: day,
                isToday: isToday,
                dayHeaderBuilder: widget.dayHeaderBuilder,
              );
            },
            contentBuilder: (context) => DayEvents(
              controller: widget.controller,
              day: day,
              dayEventsBuilder: widget.dayEventsBuilder,
            ),
          );
        },
      ),
    );
  }

  /// jump to date
  /// change initial date and redraw all list
  void jumpToDate(DateTime date) {
    if (context.mounted) {
      listenScroll = false;
      setState(() {
        initialDay = date.withoutTime;
      });
      listenScroll = true;
      mainVerticalController.jumpTo(0);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.notifyListeners();
      });
    }
  }
}

class DayEvents extends StatefulWidget {
  const DayEvents({
    super.key,
    required this.controller,
    required this.day,
    required this.dayEventsBuilder,
  });

  final EventsController controller;
  final DateTime day;
  final Widget Function(DateTime day, List<Event>? events)? dayEventsBuilder;

  @override
  State<DayEvents> createState() => _DayEventsState();
}

class _DayEventsState extends State<DayEvents> {
  late VoidCallback eventListener;
  List<Event>? events;

  @override
  void initState() {
    super.initState();
    events = widget.controller.getSortedFilteredDayEvents(widget.day);
    eventListener = () => updateEvents();
    widget.controller.addListener(eventListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  // update day events when change
  void updateEvents() {
    if (mounted) {
      var dayEvents = widget.controller.getFilteredDayEvents(widget.day);
      // no update if no change for current day
      if (listEquals(dayEvents, events) == false) {
        setState(() {
          events = dayEvents;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.dayEventsBuilder?.call(widget.day.withoutTime, events) ??
        DefaultDayEvents(events: events);
  }
}
