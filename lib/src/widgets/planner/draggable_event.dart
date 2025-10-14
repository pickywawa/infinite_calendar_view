import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../events_planner.dart';
import '../../utils/extension.dart';

class DraggableEventWidget extends StatelessWidget {
  const DraggableEventWidget({
    super.key,
    required this.event,
    required this.height,
    required this.width,
    required this.onDragEnd,
    this.onSlotMinutesRound = 15,
    this.draggableFeedback,
    required this.child,
  });

  static double defaultDraggableOpacity = 0.7;

  /// event
  final Event event;

  /// event height
  final double height;

  /// event width
  final double width;

  /// event when end drag
  final void Function(
    int columnIndex,
    DateTime exactStartDateTime,
    DateTime exactEndDateTime,
    DateTime roundStartDateTime,
    DateTime roundEndDateTime,
  ) onDragEnd;

  /// round date to nearest minutes date
  final int onSlotMinutesRound;

  /// event widget when drag
  final Widget? draggableFeedback;

  /// event widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    EventsPlannerState? plannerState;
    var oldPositionY = 0.0;
    var oldVerticalOffset = 0.0;

    return LongPressDraggable(
      feedback: draggableFeedback ?? getDefaultDraggableFeedback(),
      childWhenDragging: const SizedBox.shrink(),
      onDragStarted: () {
        plannerState = context.findAncestorStateOfType<EventsPlannerState>();
        var oldBox = context.findRenderObject() as RenderBox;
        var oldPosition = oldBox.localToGlobal(Offset.zero);
        oldPositionY = oldPosition.dy;
        oldVerticalOffset = plannerState?.mainVerticalController.offset ?? 0;
      },
      onDragUpdate: (details) {
        manageVerticalScrollOnly(plannerState, context, details);
        print(details.globalPosition);
      },
      onDragEnd: (details) {
        var renderBox = plannerState?.context.findRenderObject() as RenderBox;
        var relativeOffset = renderBox.globalToLocal(details.offset);

        // find day
        var dayWidth = plannerState?.dayWidth ?? 0;
        var heightPerMinute = plannerState?.heightPerMinute ?? 0;
        var scrollOffsetX = plannerState?.mainHorizontalController.offset ?? 0;
        var releaseOffsetX = scrollOffsetX + relativeOffset.dx;
        var dayIndex = (releaseOffsetX / dayWidth).toInt();
        // adjust negative index, because current day begin 0 and negative begin -1
        var reallyDayIndex = releaseOffsetX >= 0 ? dayIndex : dayIndex - 1;
        var currentDay = plannerState?.initialDate
                .addCalendarDays(reallyDayIndex)
                .withoutTime ??
            event.startTime.withoutTime;

        // find hour
        var scrollOffsetY = plannerState?.mainVerticalController.offset ?? 0;
        var difference = (details.offset.dy - oldPositionY) +
            (scrollOffsetY - oldVerticalOffset);
        var minuteDiff = difference / heightPerMinute;

        // exact event time
        var duration = event.endTime!.difference(event.startTime).inMinutes;
        var exactStartDateTime = currentDay.add(
          Duration(
            minutes: event.startTime.totalMinutes + minuteDiff.toInt(),
          ),
        );
        var exactEndDateTime = exactStartDateTime.add(
          Duration(
            minutes: duration,
          ),
        );

        // round event time to nearest multiple of onSlotMinutesRound minutes
        var totalMinutes = exactStartDateTime.totalMinutes;
        var totalMinutesRound =
            onSlotMinutesRound * (totalMinutes / onSlotMinutesRound).round();
        var roundStartDateTime =
            currentDay.add(Duration(minutes: totalMinutesRound));
        var roundEndDateTime =
            roundStartDateTime.add(Duration(minutes: duration));

        // find column
        var columnIndex = 0;
        var dayPosition = (releaseOffsetX % dayWidth);
        var columnsParam = plannerState?.widget.columnsParam;
        if (columnsParam != null && columnsParam.columns > 0) {
          for (var column = 0; column < columnsParam.columns; column++) {
            var positions = columnsParam.getColumPositions(width, column);
            if (positions[0] <= dayPosition && dayPosition <= positions[1]) {
              columnIndex = column;
            }
          }
        }

        onDragEnd.call(columnIndex, exactStartDateTime, exactEndDateTime,
            roundStartDateTime, roundEndDateTime);
      },
      child: child,
    );
  }

  void manageVerticalScrollOnly(
    EventsPlannerState? plannerState,
    BuildContext context,
    DragUpdateDetails details,
  ) {
    if (plannerState == null) return;

    final verticalController = plannerState.mainVerticalController;
    final renderBox = plannerState.context.findRenderObject() as RenderBox;
    final relativeOffset = renderBox.globalToLocal(details.globalPosition);

    // Allow vertical auto-scroll only (up & down)
    if (relativeOffset.dy > (0.9 * plannerState.height)) {
      // Near bottom edge → scroll down
      verticalController.jumpTo(
        verticalController.offset + 10,
      );
    } else if (relativeOffset.dy < (0.1 * plannerState.height)) {
      // Near top edge → scroll up
      verticalController.jumpTo(
        verticalController.offset - 10,
      );
    }
  }

  SizedBox getDefaultDraggableFeedback() {
    return SizedBox(
      height: height,
      width: width,
      child: Opacity(opacity: defaultDraggableOpacity, child: child),
    );
  }
}
