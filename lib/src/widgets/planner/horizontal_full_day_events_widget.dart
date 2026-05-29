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
    required this.dayWidthBuilder,
    required this.todayColor,
    required this.timesIndicatorsWidth,
    this.fixedPageExtent,
    this.fixedPageItemCount = 1,
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
  final double Function(DateTime) dayWidthBuilder;
  final Color? todayColor;
  final double timesIndicatorsWidth;
  final double? fixedPageExtent;
  final int fixedPageItemCount;

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
                negChildCount: _itemCountForMaxDays(maxPreviousDays),
                posChildCount: _itemCountForMaxDays(maxNextDays),
                itemExtent: fixedPageExtent,
                builder: (context, index) {
                  return InfiniteListItem(
                    contentBuilder: (context) {
                      if (fixedPageExtent == null) {
                        return _buildFullDayEventsCell(index);
                      }
                      // Match the planner body: fixed outer page, variable day cells.
                      return InfiniteListPage(
                        width: fixedPageExtent,
                        firstIndex: index * fixedPageItemCount,
                        itemCount: fixedPageItemCount,
                        textDirection: textDirection,
                        builder: (_, index) => _buildFullDayEventsCell(index),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullDayEventsCell(int dayIndex) {
    var day = getDayFromIndex(dayIndex);
    var isToday = DateUtils.isSameDay(day, DateTime.now());
    var currentDayWidth = dayWidthBuilder(day);

    return SizedBox(
      width: currentDayWidth,
      child: FullDayEventsWidget(
        // Full-day widgets cache events, so do not reuse state across dates.
        key: ValueKey(day),
        controller: controller,
        isToday: isToday,
        day: day,
        todayColor: todayColor,
        fullDayParam: fullDayParam,
        columnsParam: columnsParam,
        dayWidth: currentDayWidth,
        daySeparationWidthPadding: daySeparationWidthPadding,
      ),
    );
  }

  DateTime getDayFromIndex(int index) {
    return initialDate
        .addCalendarDays(textDirection == TextDirection.ltr ? index : -index);
  }

  // Child counts are still configured in days; fixed pages group several days
  // into one sliver child.
  int? _itemCountForMaxDays(int? maxDays) =>
      fixedPageExtent == null || maxDays == null
          ? maxDays
          : (maxDays / fixedPageItemCount).ceil();
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

  @override
  void didUpdateWidget(covariant FullDayEventsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The state caches filtered events, but fixed pages can reuse it for a different date.
    if (!DateUtils.isSameDay(oldWidget.day, widget.day) ||
        oldWidget.fullDayParam.showMultiDayEvents !=
            widget.fullDayParam.showMultiDayEvents) {
      updateEvents();
    }
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
