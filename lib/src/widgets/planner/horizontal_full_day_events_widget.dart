import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import '../../controller/events_controller.dart';
import '../../events/event.dart';
import '../../events_planner.dart';
import 'day_widget.dart';

class HorizontalFullDayEventsWidget extends StatelessWidget {
  const HorizontalFullDayEventsWidget({
    super.key,
    required this.controller,
    required this.fullDayParam,
    required this.daySeparationWidthPadding,
    required this.dayHorizontalController,
    required this.maxPreviousDays,
    required this.maxNextDays,
    required this.initialDate,
    required this.dayWidth,
    required this.todayColor,
    required this.timesIndicatorsWidth,
  });

  final EventsController controller;
  final FullDayParam fullDayParam;
  final double daySeparationWidthPadding;
  final ScrollController dayHorizontalController;
  final int? maxPreviousDays;
  final int? maxNextDays;
  final DateTime initialDate;
  final double dayWidth;
  final Color? todayColor;
  final double timesIndicatorsWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: fullDayParam.fullDayEventsBarDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: timesIndicatorsWidth,
            height: fullDayParam.fullDayEventsBarHeight,
            child: fullDayParam.fullDayEventsBarLeftWidget ??
                Center(
                  child: Text(
                    fullDayParam.fullDayEventsBarLeftText,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ),
          Expanded(
            child: SizedBox(
              height: fullDayParam.fullDayEventsBarHeight,
              child: InfiniteList(
                  controller: dayHorizontalController,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  direction: InfiniteListDirection.multi,
                  negChildCount: maxPreviousDays,
                  posChildCount: maxNextDays,
                  builder: (context, index) {
                    var day = initialDate.add(Duration(days: index));
                    var isToday = DateUtils.isSameDay(day, DateTime.now());
                    return InfiniteListItem(
                      contentBuilder: (context) {
                        return SizedBox(
                          width: dayWidth,
                          child: FullDayEventsWidget(
                            controller: controller,
                            isToday: isToday,
                            day: day,
                            todayColor: todayColor,
                            height: fullDayParam.fullDayEventsBarHeight,
                            dayWidth: dayWidth,
                            daySeparationWidthPadding:
                                daySeparationWidthPadding,
                            fullDayEventsBuilder:
                                fullDayParam.fullDayEventsBuilder,
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class FullDayEventsWidget extends StatefulWidget {
  const FullDayEventsWidget({
    super.key,
    required this.controller,
    required this.isToday,
    required this.day,
    required this.todayColor,
    required this.height,
    required this.dayWidth,
    required this.daySeparationWidthPadding,
    required this.fullDayEventsBuilder,
  });

  final EventsController controller;
  final bool isToday;
  final DateTime day;
  final Color? todayColor;
  final double height;
  final double dayWidth;
  final double daySeparationWidthPadding;
  final Widget Function(List<FullDayEvent> events, double width)?
      fullDayEventsBuilder;

  @override
  State<FullDayEventsWidget> createState() => _FullDayEventsWidgetState();
}

class _FullDayEventsWidgetState extends State<FullDayEventsWidget> {
  List<FullDayEvent>? events;

  late VoidCallback eventListener;

  @override
  void initState() {
    super.initState();
    eventListener = () => updateEvents();
    widget.controller.addListener(eventListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateEvents();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(eventListener);
  }

  void updateEvents() {
    if (mounted) {
      var fullDayEvents =
          widget.controller.getFilteredFullDayEvents(widget.day);

      // no update if no change for current day
      if (listEquals(fullDayEvents, events) == false) {
        setState(() {
          events = fullDayEvents;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = widget.dayWidth - (widget.daySeparationWidthPadding * 2);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: widget.daySeparationWidthPadding),
      child: Container(
        decoration:
            BoxDecoration(color: widget.isToday ? widget.todayColor : null),
        child: widget.fullDayEventsBuilder != null
            ? widget.fullDayEventsBuilder!.call(events ?? [], widget.dayWidth)
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: events
                          ?.map((e) => DefaultDayEvent(
                                height: 15,
                                width: width,
                                title: e.title,
                                description: e.description,
                                color: e.color,
                                textColor: e.textColor,
                              ))
                          .toList() ??
                      [],
                ),
              ),
      ),
    );
  }
}
