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
        manageHorizontalScroll(plannerState, context, details);
      },
      onDragEnd: (details) {
        var renderBox = plannerState?.context.findRenderObject() as RenderBox;
        var relativeOffset = renderBox.globalToLocal(details.offset);

        // find day
        var timeIndicatorWidth = plannerState?.widget.timesIndicatorsParam.timesIndicatorsWidth ?? 0;
        var scrollOffsetX = plannerState?.mainHorizontalController.offset ?? 0;

        // Use the ACTUAL event width for the midpoint calculation to fix the concurrent event bug.
        // relativeOffset.dx points to the top-left corner of the dragged widget.
        var releaseLeftOffsetX = scrollOffsetX + relativeOffset.dx - timeIndicatorWidth;
        var releaseMidpointOffsetX = releaseLeftOffsetX + (width / 2);

        var heightPerMinute = plannerState?.heightPerMinute ?? 0;

        // Use midpoint to calculate the exact destination day index
        var dayIndex = plannerState?.getIndexForOffset(releaseMidpointOffsetX, findExact: true) ?? 0;
        var currentDay = plannerState?.initialDate
            .addCalendarDays(dayIndex)
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

        // Get the actual width of the destination day (important for daysWidthRatio)
        var currentDayWidth = plannerState?.getDayWidth(currentDay) ?? plannerState?.dayWidth ?? 0;

        // Find local offset within the specific day instead of modulo to support variable day widths
        var offsetForDay = plannerState?.getOffsetForIndex(dayIndex) ?? 0;
        var dayPosition = releaseMidpointOffsetX - offsetForDay;

        var columnsParam = plannerState?.widget.columnsParam;
        if (columnsParam != null && columnsParam.columns > 0) {
          for (var column = 0; column < columnsParam.columns; column++) {
            var positions = columnsParam.getColumPositions(currentDayWidth, column);
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

  void manageHorizontalScroll(EventsPlannerState? plannerState,
      BuildContext context, DragUpdateDetails details) {
    if (plannerState != null) {
      var horizontalController = plannerState.mainHorizontalController;
      var verticalController = plannerState.mainVerticalController;
      var renderBox = plannerState.context.findRenderObject() as RenderBox;
      var relativeOffset = renderBox.globalToLocal(details.globalPosition);

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

  SizedBox getDefaultDraggableFeedback() {
    return SizedBox(
      height: height,
      width: width,
      child: Opacity(opacity: defaultDraggableOpacity, child: child),
    );
  }
}
