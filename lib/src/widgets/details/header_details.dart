import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../infinite_calendar_view.dart';

/// listen day events and update header when days events change
class HeaderListWidget extends StatefulWidget {
  const HeaderListWidget({
    required this.controller,
    required this.day,
    required this.isToday,
    required this.dayHeaderBuilder,
    super.key,
  });

  final EventsController controller;
  final DateTime day;
  final bool isToday;
  final Widget Function(
    DateTime day,
    bool isToday,
    List<Event>? events,
  )? dayHeaderBuilder;

  @override
  State<HeaderListWidget> createState() => _HeaderListWidgetState();
}

class _HeaderListWidgetState extends State<HeaderListWidget> {
  List<Event>? events;
  late VoidCallback eventListener;

  @override
  void initState() {
    super.initState();
    eventListener = updateEvents;
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

  // update day events when change
  void updateEvents() {
    if (mounted) {
      final dayEvents = widget.controller.getFilteredDayEvents(widget.day);

      // no update if no change for current day
      if (!listEquals(dayEvents, events)) {
        setState(() {
          events = dayEvents;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.dayHeaderBuilder?.call(widget.day, widget.isToday, events) ??
      DefaultHeader(dayText: widget.day.toString());
}

class DefaultHeader extends StatelessWidget {
  const DefaultHeader({
    required this.dayText,
    super.key,
  });

  static const defaultHorizontalPadding = 20.0;
  static const defaultVerticalPadding = 6.0;
  static const defaultDividerHeight = 0.0;

  final String dayText;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Column(
          children: [
            const Divider(height: defaultDividerHeight),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding,
                vertical: defaultVerticalPadding,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  dayText,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
            const Divider(height: defaultDividerHeight),
          ],
        ),
      );
}
