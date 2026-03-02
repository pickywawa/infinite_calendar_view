import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../infinite_calendar_view.dart';
import '../../utils/list/infinite_list.dart';
import '../../utils/list/models/alignments.dart';

class HorizontalFullDayEventsWidget extends StatelessWidget {
  const HorizontalFullDayEventsWidget({
    super.key,
    required this.controller,
    this.textDirection = TextDirection.ltr,
    required this.fullDayParam,
    required this.columnsParam,
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
  final TextDirection textDirection;
  final FullDayParam fullDayParam;
  final ColumnsParam columnsParam;
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
        textDirection: textDirection,
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
                      fontSize: 12,
                    ),
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
                    var day = getDayFromIndex(index);
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
                            fullDayParam: fullDayParam,
                            columnsParam: columnsParam,
                            dayWidth: dayWidth,
                            daySeparationWidthPadding:
                                daySeparationWidthPadding,
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

  DateTime getDayFromIndex(int index) {
    return initialDate
        .addCalendarDays(textDirection == TextDirection.ltr ? index : -index);
  }
}

class FullDayEventsWidget extends StatefulWidget {
  const FullDayEventsWidget({
    super.key,
    required this.controller,
    required this.isToday,
    required this.day,
    required this.todayColor,
    required this.fullDayParam,
    required this.columnsParam,
    required this.dayWidth,
    required this.daySeparationWidthPadding,
  });

  final EventsController controller;
  final bool isToday;
  final DateTime day;
  final Color? todayColor;
  final FullDayParam fullDayParam;
  final ColumnsParam columnsParam;
  final double dayWidth;
  final double daySeparationWidthPadding;

  @override
  State<FullDayEventsWidget> createState() => _FullDayEventsWidgetState();
}

class _FullDayEventsWidgetState extends State<FullDayEventsWidget> {
  List<Event>? events;

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
      var fullDayEvents = widget.controller
          .getFilteredDayEvents(
            widget.day,
            returnDayEvents: false,
            returnMultiDayEvents: widget.fullDayParam.showMultiDayEvents,
          )
          ?.reversed
          .toList();

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
        decoration: BoxDecoration(
          color: widget.isToday && widget.todayColor != null
              ? widget.todayColor
              : widget.fullDayParam.fullDayBackgroundColor,
        ),
        child: Stack(
          children: [
            // columns painters
            if (widget.columnsParam.columns > 1) getColumnPainter(width),
            getFullDayEvents(width),
          ],
        ),
      ),
    );
  }

  Widget getFullDayEvents(double width) {
    var eventTopPadding = 2.0;
    return widget.fullDayParam.fullDayEventsBuilder != null
        ? widget.fullDayParam.fullDayEventsBuilder!
            .call(events ?? [], widget.dayWidth)
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var e in events ?? [])
                  Padding(
                    padding: EdgeInsets.only(top: eventTopPadding),
                    child: widget.fullDayParam.fullDayEventBuilder
                            ?.call(e, widget.dayWidth) ??
                        DefaultDayEvent(
                          height: widget.fullDayParam.fullDayEventHeight,
                          width: width,
                          title: e.title,
                          titleFontSize: 10,
                          description: e.description,
                          color: e.color,
                          textColor: e.textColor,
                        ),
                  ),
              ],
            ),
          );
  }

  Widget getColumnPainter(double width) {
    return SizedBox(
      width: width,
      height: widget.fullDayParam.fullDayEventsBarHeight,
      child: CustomPaint(
        foregroundPainter: widget.columnsParam.columnCustomPainter
                ?.call(width, widget.columnsParam.columns) ??
            ColumnPainter(
              width: width,
              columnsParam: widget.columnsParam,
              lineColor: Theme.of(context).colorScheme.outlineVariant,
            ),
      ),
    );
  }
}
