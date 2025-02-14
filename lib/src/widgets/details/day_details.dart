import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/utils/default_text.dart';

import '../../events/event.dart';

class DefaultDayEvents extends StatelessWidget {
  const DefaultDayEvents({
    super.key,
    required this.events,
    this.eventBuilder,
    this.eventSeparator = defaultEventSeparator,
    this.emptyEventsWidget = defaultEmptyEventsWidget,
    this.nullEventsWidget = defaultNullEventsWidget,
  });

  static const defaultNoEventText = "No event";
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
          events?.map((event) => getEventAndSeparator(event)).toList() ?? [],
    );
  }

  Column getEventAndSeparator(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        eventBuilder?.call(event) ?? DefaultDetailEvent(event: event),
        if (eventSeparator != null &&
            events!.indexOf(event) != events!.length - 1)
          eventSeparator!,
      ],
    );
  }
}

class DefaultDetailEvent extends StatelessWidget {
  const DefaultDetailEvent({
    super.key,
    required this.event,
    this.onTap,
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

  final Event event;
  final GestureTapCallback? onTap;
  final Widget? leftWidget;
  final Widget? centerWidget;
  final Widget? rightWidget;
  final String? timeText;
  final String? durationText;

  @override
  Widget build(BuildContext context) {
    String? durationText = this.durationText;
    var timeText = this.timeText ?? defaultFullDayText;
    var event = this.event;
    if (!event.isFullDay) {
      var startTime = event.startTime;
      timeText = this.timeText ??
          "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
      durationText = this.getDurationText(event.startTime, event.endTime!);
    }
    return InkWell(
      onTap: () => onTap?.call(),
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

  Flexible getContent(BuildContext context) {
    return Flexible(
      flex: defaultContentFit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.title?.isNotEmpty == true)
            Text(
              event.title ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (event.description?.isNotEmpty == true)
            Text(
              event.description ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Flexible getColoredCircle() {
    return Flexible(
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
  }

  Flexible getHour(
      String timeText, String? durationText, BuildContext context) {
    return Flexible(
      flex: defaultDateFit,
      fit: FlexFit.tight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
  }

  String getDurationText(DateTime startDate, DateTime endDate) {
    var duration = endDate.difference(startDate);
    var element = <String>[];
    if (duration.inHours > 0) {
      element.add("${duration.inHours}h");
    }
    var minutes = duration.inMinutes.remainder(60);
    if (minutes > 0) {
      element.add("${minutes}m");
    }
    return element.join("");
  }
}
