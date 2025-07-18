import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/models/alignments.dart';
import 'package:sticky_infinite_list/widget.dart';

import '../../../infinite_calendar_view.dart';
import '../../utils/extension.dart';

class HorizontalDaysIndicatorWidget extends StatelessWidget {
  const HorizontalDaysIndicatorWidget({
    required this.daysHeaderParam,
    required this.columnsParam,
    required this.timesIndicatorsWidth,
    required this.dayHorizontalController,
    required this.maxPreviousDays,
    required this.maxNextDays,
    required this.initialDate,
    required this.dayWidth,
    super.key,
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
    final defaultHeaderBackgroundColor =
        Theme.of(context).appBarTheme.backgroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: daysHeaderParam.daysHeaderColor ?? defaultHeaderBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: timesIndicatorsWidth),
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
              final day = initialDate.add(Duration(days: index));
              final isToday = DateUtils.isSameDay(day, DateTime.now());

              return InfiniteListItem(
                contentBuilder: (context) => SizedBox(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  DefaultDayHeader getDefaultDayHeader(DateTime day, bool isToday) =>
      DefaultDayHeader(
        dayText: daysHeaderParam.dayHeaderTextBuilder?.call(day) ??
            '${day.day}/${day.month}',
        isToday: isToday,
        foregroundColor: daysHeaderParam.daysHeaderForegroundColor,
      );

  Row getColumnsHeader(BuildContext context, DateTime day, bool isToday) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = colorScheme.surface;
    final builder = columnsParam.columnHeaderBuilder;
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
    required this.columnText,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.columnWidth,
    super.key,
  });

  final String columnText;
  final Color backgroundColor;
  final Color foregroundColor;
  final double columnWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: columnWidth,
        child: Center(
          child: DecoratedBox(
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

class DefaultDayHeader extends StatelessWidget {
  const DefaultDayHeader({
    required this.dayText,
    super.key,
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
    final colorScheme = Theme.of(context).colorScheme;
    final defaultForegroundColor = context.isDarkMode
        ? Theme.of(context).colorScheme.primary
        : colorScheme.onPrimary;
    final fgColor = foregroundColor ?? defaultForegroundColor;
    final todayBgColor = todayBackgroundColor ?? colorScheme.surface;
    final todayFgColor = todayForegroundColor ?? colorScheme.primary;

    return Center(
      child: isToday
          ? DecoratedBox(
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

  TextStyle getDefaultStyle(Color fgColor) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: fgColor,
      );
}
