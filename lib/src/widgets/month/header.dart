import 'package:flutter/material.dart';
import '../../events_months.dart';
import '../../utils/default_text.dart';
import '../../utils/extension.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({
    required this.weekParam,
    super.key,
  });

  final WeekParam weekParam;

  @override
  Widget build(BuildContext context) {
    final startOfWeek = weekParam.startOfWeekDay;

    return Container(
      height: weekParam.headerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: Row(
        children: [
          for (var dayOfWeek = startOfWeek;
              dayOfWeek < startOfWeek + 7;
              dayOfWeek++)
            Expanded(
              child:
                  weekParam.headerDayBuilder?.call(((dayOfWeek - 1) % 7) + 1) ??
                      getDefaultHeaderDay(context, (dayOfWeek - 1) % 7),
            )
        ],
      ),
    );
  }

  Widget getDefaultHeaderDay(BuildContext context, int dayOfWeek) => Center(
        child: Text(
          weekParam.headerDayText?.call(dayOfWeek + 1) ??
              defaultDaysOfWeekText[dayOfWeek],
          style:
              weekParam.headerStyle ?? getDefaultTextStyle(context, dayOfWeek),
        ),
      );

  TextStyle getDefaultTextStyle(BuildContext context, int dayOfWeek) {
    final defaultForegroundColor = context.isDarkMode
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;
    final textColor = weekParam.headerDayTextColor?.call(dayOfWeek + 1) ??
        defaultForegroundColor;
    return const TextStyle().copyWith(
      color: (dayOfWeek >= 5) ? textColor.darken() : textColor,
      fontWeight: FontWeight.w700,
      fontSize: 13,
    );
  }
}
