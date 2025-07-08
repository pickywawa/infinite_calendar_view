import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import '../../../infinite_calendar_view.dart';

class HorizontalDaysIndicatorWidget extends StatelessWidget {
  const HorizontalDaysIndicatorWidget({
    super.key,
    required this.daysHeaderParam,
    required this.columnsParam,
    required this.timesIndicatorsWidth,
    required this.dayHorizontalController,
    required this.maxPreviousDays,
    required this.maxNextDays,
    required this.initialDate,
    required this.dayWidth,
  });

  final DaysHeaderParam daysHeaderParam;
  final ColumnsParam columnsParam;
  final double timesIndicatorsWidth;
  final ScrollController dayHorizontalController;
  final int? maxPreviousDays;
  final int? maxNextDays;
  final DateTime initialDate;
  final double dayWidth;

  @override
  Widget build(BuildContext context) {
    // take appbar background color first
    var defaultHeaderBackgroundColor =
        Theme.of(context).appBarTheme.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: daysHeaderParam.daysHeaderColor ?? defaultHeaderBackgroundColor,
      ),
      child: Padding(
        padding: Directionality.of(context) == TextDirection.rtl
            ? EdgeInsets.only(right: timesIndicatorsWidth)
            : EdgeInsets.only(left: timesIndicatorsWidth),
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
              var day = initialDate.add(Duration(days: index));
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
                          getColumnsHeader(context, day, isToday)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  DefaultDayHeader getDefaultDayHeader(DateTime day, bool isToday) {
    return DefaultDayHeader(
      dayText: daysHeaderParam.dayHeaderTextBuilder?.call(day) ??
          "${day.day}/${day.month}",
      isToday: isToday,
      foregroundColor: daysHeaderParam.daysHeaderForegroundColor,
    );
  }

  Row getColumnsHeader(BuildContext context, DateTime day, bool isToday) {
    var colorScheme = Theme.of(context).colorScheme;
    var bgColor = colorScheme.surface;
    var builder = columnsParam.columnHeaderBuilder;
    return Row(
      children: [
        for (var column = 0; column < columnsParam.columns; column++)
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
              foregroundColor: columnsParam.columnsForegroundColors?[column] ??
                  colorScheme.primary,
            )
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
