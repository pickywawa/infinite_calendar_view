import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../utils/default_text.dart';

class DefaultDayEvents extends StatelessWidget {
  const DefaultDayEvents({
    required this.events, super.key,
    this.eventBuilder,
    this.eventSeparator = defaultEventSeparator,
    this.emptyEventsWidget = defaultEmptyEventsWidget,
    this.nullEventsWidget = defaultNullEventsWidget,
  });

  static const defaultNoEventText = 'No event';
  static const defaultHorizontalPadding = 20.0;
  static const defaultVerticalSmallPadding = 10.0;
  static const defaultVerticalPadding = 20.0;

  static const defaultEventSeparator = Padding(
    padding: EdgeInsets.only(left: defaultHorizontalPadding),
    child: Divider(height: 1),
  );

  static const defaultEmptyEventsWidget = Padding(
    padding: EdgeInsets.symmetric(
        vertical: defaultVerticalSmallPadding,
        horizontal: defaultHorizontalPadding),
    child: Text(defaultNoEventText, textAlign: TextAlign.left),
  );

  static const defaultNullEventsWidget = Padding(
    padding: EdgeInsets.symmetric(vertical: defaultVerticalSmallPadding),
    child: Center(child: CircularProgressIndicator()),
  );

  final List<Event>? events;

  /// events builder
  /// for listening event tap, it's possible to add gesture detector to dayEventsBuilder
  final Widget Function(Event event)? eventBuilder;

  /// separation between two event in one day
  final Widget? eventSeparator;

  /// widget when day events are empty
  final Widget emptyEventsWidget;

  /// widget when day events are null (ex no already loaded)
  final Widget? nullEventsWidget;

  @override
  Widget build(BuildContext context) {
    if (nullEventsWidget != null && events == null) {
      return nullEventsWidget!;
    }
    if (events?.isEmpty == true) {
      return emptyEventsWidget;
    }
    return Column(
      children:
          events?.map(getEventAndSeparator).toList() ?? [],
    );
  }

  Column getEventAndSeparator(Event event) => Column(
      children: [
        eventBuilder?.call(event) ?? DefaultDetailEvent(event: event),
        if (eventSeparator != null &&
            events!.indexOf(event) != events!.length - 1)
          eventSeparator!,
      ],
    );
}

/// Default detail event
/// can be replaced in dayEventsBuilder -> eventBuilder
class DefaultDetailEvent extends StatelessWidget {
  const DefaultDetailEvent({
    required this.event, super.key,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.leftWidget,
    this.centerWidget,
    this.rightWidget,
    this.timeText,
    this.durationText,
  });

  static const defaultCircleColorSize = 10.0;
  static const defaultDateFit = 3;
  static const defaultColoredCircleFit = 2;
  static const defaultContentFit = 14;

  /// Event
  final Event event;

  /// InkWell tap gesture
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;

  /// to custom left widget
  final Widget? leftWidget;

  /// to custom center widget
  final Widget? centerWidget;

  /// to custom right widget
  final Widget? rightWidget;

  /// to custom default hour/minute
  final String? timeText;

  /// to custom default duration
  final String? durationText;

  @override
  Widget build(BuildContext context) {
    final event = this.event;

    String? durationText;
    String? timeText;
    if (event.isFullDay) {
      timeText = this.timeText ?? defaultFullDayText;
    } else {
      final startTime = event.startTime;
      timeText = this.timeText ?? getDefaultTimeText(startTime);
      durationText = this.durationText ??
          getDefaultDurationText(event.startTime, event.endTime!);
    }

    return InkWell(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DefaultDayEvents.defaultHorizontalPadding,
          vertical: DefaultDayEvents.defaultVerticalPadding,
        ),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date and duration
              leftWidget ?? getHour(timeText, durationText, context),
              // colored circle
              centerWidget ?? getColoredCircle(),
              // content (title and description)
              rightWidget ?? getContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Flexible getContent(BuildContext context) => Flexible(
      flex: defaultContentFit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.title?.isNotEmpty == true)
            Text(
              event.title ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (event.description?.isNotEmpty == true)
            Text(
              event.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

  Flexible getColoredCircle() => Flexible(
      flex: defaultColoredCircleFit,
      fit: FlexFit.tight,
      child: Container(
        width: defaultCircleColorSize,
        height: defaultCircleColorSize,
        margin: const EdgeInsets.only(top: defaultCircleColorSize / 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: event.color,
        ),
      ),
    );

  Flexible getHour(
    String timeText,
    String? durationText,
    BuildContext context,
  ) => Flexible(
      flex: defaultDateFit,
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeText),
          if (durationText != null)
            Text(
              durationText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
        ],
      ),
    );

  String getDefaultTimeText(DateTime startTime) => "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";

  String getDefaultDurationText(DateTime startDate, DateTime endDate) {
    final duration = endDate.difference(startDate);
    final element = <String>[];
    if (duration.inHours > 0) {
      element.add('${duration.inHours}h');
    }
    final minutes = duration.inMinutes.remainder(60);
    if (minutes > 0) {
      element.add("$minutes${duration.inHours == 0 ? "m" : ""}");
    }
    return element.join();
  }
}
