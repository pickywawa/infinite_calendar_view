import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/events/event.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';

class DefaultMonthDayHeader extends StatelessWidget {
  const DefaultMonthDayHeader({
    super.key,
    required this.text,
    this.isToday = false,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.textColor,
    this.todayTextColor,
    this.todayBackgroundColor,
  });

  final String text;
  final bool isToday;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final Color? todayTextColor;
  final Color? todayBackgroundColor;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var todayBgColor = todayBackgroundColor ?? colorScheme.primary;
    var todayFgColor = todayTextColor ?? colorScheme.onPrimary;
    var fgColor = textColor ?? colorScheme.outline;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: isToday ? todayBgColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            text,
            style: TextStyle().copyWith(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: isToday ? todayFgColor : fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultNotShowedMonthEventsWidget extends StatelessWidget {
  const DefaultNotShowedMonthEventsWidget({
    super.key,
    required this.context,
    required this.eventHeight,
    required this.text,
    this.textStyle,
    this.textPadding = const EdgeInsets.all(2),
    this.decoration,
  });

  final BuildContext context;
  final double eventHeight;
  final String text;
  final TextStyle? textStyle;
  final EdgeInsets textPadding;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: eventHeight,
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant.lighten(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
      child: Padding(
        padding: textPadding,
        child: Text(
          text,
          style: textStyle ?? TextStyle().copyWith(fontSize: 10),
        ),
      ),
    );
  }
}

class DraggableMonthEvent extends StatelessWidget {
  const DraggableMonthEvent({
    super.key,
    required this.child,
    this.draggableFeedback,
    required this.onDragEnd,
  });

  static double defaultDraggableOpacity = 0.7;
  final Widget child;
  final Widget? draggableFeedback;
  final void Function(DateTime day) onDragEnd;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: onDragEnd,
      feedback: draggableFeedback ?? getDefaultDraggableFeedback(),
      childWhenDragging: SizedBox.shrink(),
      child: child,
    );
  }

  Widget getDefaultDraggableFeedback() {
    return Opacity(
      opacity: defaultDraggableOpacity,
      child: child,
    );
  }
}

/// default event showed
class DefaultMonthDayEvent extends StatelessWidget {
  const DefaultMonthDayEvent({
    super.key,
    required this.event,
    this.fontSize = 10,
    this.fontWeight = FontWeight.w400,
    this.padding = const EdgeInsets.all(2),
    this.roundBorderRadius = 3,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.fullDayBorder,
  });

  final Event event;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final double roundBorderRadius;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final Border? fullDayBorder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundBorderRadius),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: event.color,
            border: event.isFullDay
                ? fullDayBorder ??
                    Border(left: BorderSide(color: event.textColor, width: 3))
                : null,
          ),
          child: Padding(
            padding: padding,
            child: Text(
              event.title ?? "",
              style: TextStyle().copyWith(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: event.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
