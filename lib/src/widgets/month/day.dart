import 'package:flutter/material.dart';
import '../../events/event.dart';
import '../../utils/extension.dart';

class DefaultMonthDayHeader extends StatelessWidget {
  const DefaultMonthDayHeader({
    required this.text, super.key,
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
    final colorScheme = Theme.of(context).colorScheme;
    final todayBgColor = todayBackgroundColor ?? colorScheme.primary;
    final todayFgColor = todayTextColor ?? colorScheme.onPrimary;
    final fgColor = textColor ?? colorScheme.outline;
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isToday ? todayBgColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            text,
            style: const TextStyle().copyWith(
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
    required this.context, required this.eventHeight, required this.text, super.key,
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
  Widget build(BuildContext context) => Container(
      height: eventHeight,
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant.lighten(),
            borderRadius: BorderRadius.circular(3),
          ),
      child: Padding(
        padding: textPadding,
        child: Text(
          text,
          style: textStyle ?? const TextStyle().copyWith(fontSize: 10),
        ),
      ),
    );
}

class DraggableMonthEvent extends StatelessWidget {
  const DraggableMonthEvent({
    required this.child, required this.onDragEnd, super.key,
    this.draggableFeedback,
  });

  static var defaultDraggableOpacity = 0.7;
  final Widget child;
  final Widget? draggableFeedback;
  final void Function(DateTime day) onDragEnd;

  @override
  Widget build(BuildContext context) => LongPressDraggable(
      data: onDragEnd,
      feedback: draggableFeedback ?? getDefaultDraggableFeedback(),
      childWhenDragging: const SizedBox.shrink(),
      child: child,
    );

  Widget getDefaultDraggableFeedback() => Opacity(
      opacity: defaultDraggableOpacity,
      child: child,
    );
}

/// default event showed
class DefaultMonthDayEvent extends StatelessWidget {
  const DefaultMonthDayEvent({
    required this.event, super.key,
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

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(roundBorderRadius),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: event.color,
            border: event.isFullDay
                ? Border(left: BorderSide(color: event.textColor, width: 3))
                : null,
          ),
          child: Padding(
            padding: padding,
            child: Text(
              event.title ?? '',
              style: const TextStyle().copyWith(
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
