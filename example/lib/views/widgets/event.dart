import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class CustomEventWidgetExample extends StatelessWidget {
  const CustomEventWidgetExample(
    this.controller,
    this.event,
    this.height,
    this.width,
  );

  final EventsController controller;
  final Event event;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return DraggableEventWidget(
      event: event,
      height: height,
      width: width,
      onDragEnd: (columnIndex, exactStart, exactEnd, roundStart, roundEnd) {
        controller.updateCalendarData(
          (data) => data.updateEvent(
            oldEvent: event,
            newEvent: event.copyWith(
              columnIndex: columnIndex,
              startTime: roundStart,
              endTime: roundEnd,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: height,
            width: width,
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Container(
                  width: 5,
                  color: event.color,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            getSlotHourText(event.startTime, event.endTime!),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            event.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        if (event.description?.isNotEmpty == true)
                          Flexible(
                            child: Text(
                              event.description ?? "",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
