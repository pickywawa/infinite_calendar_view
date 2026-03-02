import 'dart:math';

import 'package:flutter/material.dart';

import '../../../infinite_calendar_view.dart';
import '../../utils/list/infinite_list.dart';
import '../../utils/list/models/alignments.dart';

class HorizontalDaysIndicatorWidget extends StatelessWidget {
  const HorizontalDaysIndicatorWidget({
    super.key,
    this.textDirection = TextDirection.ltr,
    required this.daysHeaderParam,
    required this.columnsParam,
    required this.startColumnIndex,
    required this.onColumnIndexChanged,
    required this.timesIndicatorsWidth,
    required this.dayHorizontalController,
    required this.maxPreviousDays,
    required this.maxNextDays,
    required this.initialDate,
    required this.dayWidth,
    required this.topLeftCellValueNotifier,
  });

  final TextDirection textDirection;
  final DaysHeaderParam daysHeaderParam;
  final ColumnsParam columnsParam;
  final int startColumnIndex;
  final Function(int newStartColumnIndex) onColumnIndexChanged;
  final double timesIndicatorsWidth;
  final ScrollController dayHorizontalController;
  final int? maxPreviousDays;
  final int? maxNextDays;
  final DateTime initialDate;
  final double dayWidth;
  final ValueNotifier<DateTime> topLeftCellValueNotifier;

  @override
  Widget build(BuildContext context) {
    // take appbar background color first
    var defaultHeaderBackgroundColor =
        Theme.of(context).appBarTheme.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: daysHeaderParam.daysHeaderColor ?? defaultHeaderBackgroundColor,
      ),
      child: Row(
        textDirection: textDirection,
        children: [
          SizedBox(
            height: daysHeaderParam.daysHeaderHeight,
            width: timesIndicatorsWidth,
            child: TopLeftCell(
              topLeftCellValueNotifier: topLeftCellValueNotifier,
              topLeftCellBuilder: daysHeaderParam.topLeftCellBuilder,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: daysHeaderParam.daysHeaderHeight,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (daysHeaderParam.daysHeaderVisibility)
                              daysHeaderParam.dayHeaderBuilder != null
                                  ? daysHeaderParam.dayHeaderBuilder!
                                      .call(day, isToday)
                                  : getDefaultDayHeader(day, isToday),
                            if (columnsParam.columns > 1 ||
                                columnsParam.columnHeaderBuilder != null ||
                                columnsParam.columnsLabels.isNotEmpty)
                              getColumnsHeader(context, startColumnIndex,
                                  onColumnIndexChanged, day, isToday)
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  DateTime getDayFromIndex(int index) {
    return initialDate
        .addCalendarDays(textDirection == TextDirection.ltr ? index : -index);
  }

  DefaultDayHeader getDefaultDayHeader(DateTime day, bool isToday) {
    return DefaultDayHeader(
      dayText: daysHeaderParam.dayHeaderTextBuilder?.call(day) ??
          "${day.day}/${day.month}",
      isToday: isToday,
      foregroundColor: daysHeaderParam.daysHeaderForegroundColor,
    );
  }

  Widget getColumnsHeader(
    BuildContext context,
    int startColumnIndex,
    Function(int newStartColumnIndex) onColumnIndexChanged,
    DateTime day,
    bool isToday,
  ) {
    var colorScheme = Theme.of(context).colorScheme;
    var bgColor = colorScheme.surface;
    var builder = columnsParam.columnHeaderBuilder;
    var endColumnIndex = min(
        columnsParam.maxColumns != null
            ? startColumnIndex + columnsParam.maxColumns!
            : columnsParam.columns,
        columnsParam.columns);
    return Stack(
      children: [
        // left previous columns icons
        if (startColumnIndex > 0 && columnsParam.maxColumns != null)
          Positioned(
            left: 0,
            child: IconButton(
              icon: columnsParam.previousColumnsIcon ??
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              onPressed: () {
                var newStartColumnIndex =
                    max(0, startColumnIndex - columnsParam.maxColumns!);
                onColumnIndexChanged.call(newStartColumnIndex);
              },
            ),
          ),

        // right next columns icon
        if (endColumnIndex < columnsParam.columns &&
            columnsParam.maxColumns != null)
          Positioned(
            right: 0,
            child: IconButton(
              icon: columnsParam.nextColumnsIcon ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              onPressed: () {
                var newStartColumnIndex = min(
                  columnsParam.columns - columnsParam.maxColumns!,
                  startColumnIndex + columnsParam.maxColumns!,
                );
                onColumnIndexChanged.call(newStartColumnIndex);
              },
            ),
          ),

        // columns
        Row(
          children: [
            for (var column = startColumnIndex;
                column < endColumnIndex;
                column++)
              if (builder != null)
                builder.call(day, isToday, column,
                    columnsParam.getColumSize(dayWidth, column))
              else
                DefaultColumnHeader(
                  columnText: columnsParam.columnsLabels[column],
                  columnWidth: columnsParam.getColumSize(dayWidth, column),
                  backgroundColor: columnsParam.columnsColors.isNotEmpty
                      ? columnsParam.columnsColors[column]
                      : bgColor,
                  foregroundColor:
                      columnsParam.columnsForegroundColors?[column] ??
                          colorScheme.primary,
                )
          ],
        ),
      ],
    );
  }
}

class DefaultColumnHeader extends StatelessWidget {
  const DefaultColumnHeader({
    super.key,
    required this.columnText,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.columnWidth,
  });

  final String columnText;
  final Color backgroundColor;
  final Color foregroundColor;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: columnWidth,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              columnText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultDayHeader extends StatelessWidget {
  const DefaultDayHeader({
    super.key,
    required this.dayText,
    this.isToday = false,
    this.foregroundColor,
    this.todayForegroundColor,
    this.todayBackgroundColor,
    this.textStyle,
  });

  /// day text
  final String dayText;

  final bool isToday;

  /// day text color
  final Color? foregroundColor;

  /// today text color
  final Color? todayForegroundColor;

  /// today background color
  final Color? todayBackgroundColor;

  /// text TextStyle
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var defaultForegroundColor = context.isDarkMode
        ? Theme.of(context).colorScheme.primary
        : colorScheme.onPrimary;
    var fgColor = foregroundColor ?? defaultForegroundColor;
    var todayBgColor = todayBackgroundColor ?? colorScheme.surface;
    var todayFgColor = todayForegroundColor ?? colorScheme.primary;

    return Center(
      child: isToday
          ? Container(
              decoration: BoxDecoration(
                color: todayBgColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Text(
                  dayText,
                  textAlign: TextAlign.center,
                  style: textStyle ?? getDefaultStyle(todayFgColor),
                ),
              ),
            )
          : Text(
              dayText,
              textAlign: TextAlign.center,
              style: textStyle ?? getDefaultStyle(fgColor),
            ),
    );
  }

  TextStyle getDefaultStyle(Color fgColor) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: fgColor,
    );
  }
}

class TopLeftCell extends StatefulWidget {
  const TopLeftCell({
    super.key,
    required this.topLeftCellValueNotifier,
    this.topLeftCellBuilder,
  });

  final ValueNotifier<DateTime> topLeftCellValueNotifier;
  final Widget Function(DateTime day)? topLeftCellBuilder;

  @override
  State<TopLeftCell> createState() => TopLeftCellState();
}

class TopLeftCellState extends State<TopLeftCell> {
  @override
  void initState() {
    super.initState();

    // rebuild when day change
    widget.topLeftCellValueNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.topLeftCellBuilder
          ?.call(widget.topLeftCellValueNotifier.value),
    );
  }
}
