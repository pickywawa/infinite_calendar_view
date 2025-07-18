import 'package:flutter/material.dart';

import '../../events/event.dart';
import '../../events_planner.dart';
import '../../utils/extension.dart';

class DraggableEventWidget extends StatelessWidget {
  const DraggableEventWidget({
    required this.event,
    required this.height,
    required this.width,
    required this.onDragEnd,
    required this.child,
    super.key,
    this.onSlotMinutesRound = 15,
    this.draggableFeedback,
  });

  static var defaultDraggableOpacity = 0.7;

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
        final oldBox = context.findRenderObject()! as RenderBox;
        final oldPosition = oldBox.localToGlobal(Offset.zero);
        oldPositionY = oldPosition.dy;
        oldVerticalOffset = plannerState?.mainVerticalController.offset ?? 0;
      },
      onDragUpdate: (details) {
        manageHorizontalScroll(plannerState, context, details);
      },
      onDragEnd: (details) {
        final renderBox =
            plannerState!.context.findRenderObject()! as RenderBox;
        final relativeOffset = renderBox.globalToLocal(details.offset);

        // find day
        final dayWidth = plannerState?.dayWidth ?? 0;
        final heightPerMinute = plannerState?.heightPerMinute ?? 0;
        final scrollOffsetX =
            plannerState?.mainHorizontalController.offset ?? 0;
        final releaseOffsetX = scrollOffsetX + relativeOffset.dx;
        final dayIndex = (releaseOffsetX / dayWidth).toInt();
        // adjust negative index, because current day begin 0 and negative begin -1
        final reallyDayIndex = releaseOffsetX >= 0 ? dayIndex : dayIndex - 1;
        final currentDay = plannerState?.initialDate
                .add(Duration(days: reallyDayIndex))
                .withoutTime ??
            event.startTime.withoutTime;

        // find hour
        final scrollOffsetY = plannerState?.mainVerticalController.offset ?? 0;
        final difference = (details.offset.dy - oldPositionY) +
            (scrollOffsetY - oldVerticalOffset);
        final minuteDiff = difference / heightPerMinute;

        // exact event time
        final duration = event.endTime!.difference(event.startTime).inMinutes;
        final exactStartDateTime = currentDay.add(
          Duration(
            minutes: event.startTime.totalMinutes + minuteDiff.toInt(),
          ),
        );
        final exactEndDateTime = exactStartDateTime.add(
          Duration(
            minutes: duration,
          ),
        );

        // round event time to nearest multiple of onSlotMinutesRound minutes
        final totalMinutes = exactStartDateTime.totalMinutes;
        final totalMinutesRound =
            onSlotMinutesRound * (totalMinutes / onSlotMinutesRound).round();
        final roundStartDateTime = currentDay.add(
          Duration(
            minutes: totalMinutesRound,
          ),
        );
        final roundEndDateTime = roundStartDateTime.add(
          Duration(
            minutes: duration,
          ),
        );

        // find column
        var columnIndex = 0;
        final dayPosition = releaseOffsetX % dayWidth;
        final columnsParam = plannerState?.widget.columnsParam;
        if (columnsParam != null && columnsParam.columns > 0) {
          for (var column = 0; column < columnsParam.columns; column++) {
            final positions = columnsParam.getColumPositions(dayWidth, column);
            if (positions[0] <= dayPosition && dayPosition <= positions[1]) {
              columnIndex = column;
            }
          }
        }

        onDragEnd.call(
          columnIndex,
          exactStartDateTime,
          exactEndDateTime,
          roundStartDateTime,
          roundEndDateTime,
        );
      },
      child: child,
    );
  }

  void manageHorizontalScroll(
    EventsPlannerState? plannerState,
    BuildContext context,
    DragUpdateDetails details,
  ) {
    if (plannerState != null) {
      final horizontalController = plannerState.mainHorizontalController;
      final verticalController = plannerState.mainVerticalController;
      final renderBox = plannerState.context.findRenderObject()! as RenderBox;
      final relativeOffset = renderBox.globalToLocal(details.globalPosition);

      //var dx = details.localPosition.dx;
      if (relativeOffset.dx > (0.9 * plannerState.width)) {
        horizontalController.jumpTo(horizontalController.offset + 20);
      }
      if (relativeOffset.dx < (0.1 * plannerState.width)) {
        horizontalController.jumpTo(horizontalController.offset - 20);
      }
      if (relativeOffset.dy > (0.9 * plannerState.height)) {
        verticalController.jumpTo(verticalController.offset + 10);
      }
      if (relativeOffset.dy < (0.1 * plannerState.height)) {
        verticalController.jumpTo(verticalController.offset - 10);
      }
    }
  }

  SizedBox getDefaultDraggableFeedback() => SizedBox(
        height: height,
        width: width,
        child: Opacity(
          opacity: defaultDraggableOpacity,
          child: child,
        ),
      );
}
