import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';

class InteractiveSlot extends StatefulWidget {
  const InteractiveSlot({
    super.key,
    required this.slot,
    required this.dayWidth,
    required this.dayParam,
    required this.columnsParam,
    required this.heightPerMinute,
    required this.onChanged,
  });

  final SlotSelection slot;
  final double dayWidth;
  final DayParam dayParam;
  final ColumnsParam columnsParam;
  final double heightPerMinute;
  final void Function(SlotSelection? updatedSlot) onChanged;

  @override
  State<InteractiveSlot> createState() => _InteractiveSlotState();
}

class _InteractiveSlotState extends State<InteractiveSlot> {
  DateTime initialStartDateTime = DateTime.now();
  var startHandleStartDate = DateTime.now();
  var startHandleEndDate = DateTime.now();
  var startHandleDuration = 0;
  var startHandleY = 0.0;

  @override
  Widget build(BuildContext context) {
    var slotSelectionParam = widget.dayParam.slotSelectionParam;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        slotSelectionParam.onSlotSelectionTap?.call(widget.slot);
        widget.onChanged(null);
      },
      onLongPressStart: (details) {
        slotSelectionParam.onSlotSelectionLongPress?.call(widget.slot);
        if (slotSelectionParam.canDragSlotSelectionAfterShow) {
          initialStartDateTime = widget.slot.startDateTime;
        }
      },
      onLongPressMoveUpdate: (details) {
        if (slotSelectionParam.canDragSlotSelectionAfterShow) {
          var slotSelection = widget.slot;
          var round = widget.dayParam.onSlotMinutesRound;
          final minutesDelta =
              details.localOffsetFromOrigin.dy / widget.heightPerMinute;
          var minutesDeltaRound = widget.dayParam.onSlotRoundAlwaysBefore
              ? round * (minutesDelta / round).floor()
              : round * (minutesDelta / round).round();
          final daysDelta =
              (details.localOffsetFromOrigin.dx / widget.dayWidth).round();
          final newStart = initialStartDateTime
              .add(Duration(days: daysDelta, minutes: minutesDeltaRound));
          widget.onChanged(SlotSelection(
              slotSelection.columnIndex,
              slotSelection.initialStartDateTime,
              newStart,
              slotSelection.durationInMinutes));
        }
      },
      child: Stack(
        children: [
          // slot build
          Positioned.fill(
            child: slotSelectionParam.slotSelectionContentBuilder
                    ?.call(widget.slot) ??
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(80),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 15.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getDefaultText(widget.slot),
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
          ),

          // Top handle
          if (slotSelectionParam.enableSlotSelectionResize)
            Align(
              alignment: Alignment.topCenter,
              child: RawGestureDetector(
                gestures: {
                  VerticalDragGestureRecognizer: getTopHandleGesture(),
                },
                child:
                    slotSelectionParam.slotSelectionTopHandleBuilder?.call() ??
                        Container(
                          height: 15,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: const Icon(Icons.drag_handle, size: 12),
                        ),
              ),
            ),

          // Bottom handle
          if (slotSelectionParam.enableSlotSelectionResize)
            Align(
              alignment: Alignment.bottomCenter,
              child: RawGestureDetector(
                gestures: {
                  VerticalDragGestureRecognizer: getBottomHandleGesture(),
                },
                child: slotSelectionParam.slotSelectionBottomHandleBuilder
                        ?.call() ??
                    Container(
                      height: 15,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: const Icon(Icons.drag_handle, size: 12),
                    ),
              ),
            ),
        ],
      ),
    );
  }

  GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>
      getTopHandleGesture() {
    return GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
      () => VerticalDragGestureRecognizer(),
      (instance) {
        instance.onStart = (details) {
          startHandleStartDate = widget.slot.startDateTime;
          startHandleEndDate = widget.slot.startDateTime
              .add(Duration(minutes: widget.slot.durationInMinutes));
          startHandleY = details.localPosition.dy;
        };
        instance.onUpdate = (details) {
          if (startHandleY != 0) {
            final round = widget.dayParam.onSlotMinutesRound;
            final minutesDelta = ((details.localPosition.dy - startHandleY) /
                    widget.heightPerMinute)
                .round();
            final minutesDeltaRounded = round * (minutesDelta / round).round();
            final newStart = startHandleStartDate
                .add(Duration(minutes: minutesDeltaRounded));
            final newDuration =
                startHandleEndDate.totalMinutes - newStart.totalMinutes;
            if (newDuration != widget.slot.durationInMinutes &&
                newDuration >= round) {
              widget.onChanged(SlotSelection(widget.slot.columnIndex,
                  widget.slot.initialStartDateTime, newStart, newDuration));
            }
          }
        };
        // round date when end scale
        instance.onEnd = (details) {
          startHandleDuration = 0;
          startHandleY = 0;
        };
      },
    );
  }

  GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>
      getBottomHandleGesture() {
    return GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
      () => VerticalDragGestureRecognizer(),
      (instance) {
        instance.onStart = (details) {
          startHandleDuration = widget.slot.durationInMinutes;
          startHandleY = details.localPosition.dy;
        };
        instance.onUpdate = (details) {
          if (startHandleY != 0) {
            final minutesDelta = ((details.localPosition.dy - startHandleY) /
                    widget.heightPerMinute)
                .round();
            final minutesDeltaRounded = widget.dayParam.onSlotMinutesRound *
                (minutesDelta / widget.dayParam.onSlotMinutesRound).round();
            final newDuration = startHandleDuration + minutesDeltaRounded;
            if (newDuration != widget.slot.durationInMinutes &&
                newDuration >= widget.dayParam.onSlotMinutesRound) {
              widget.onChanged(SlotSelection(
                widget.slot.columnIndex,
                widget.slot.initialStartDateTime,
                widget.slot.startDateTime,
                newDuration,
              ));
            }
          }
        };
        // round duration when end scale
        instance.onEnd = (details) {
          startHandleDuration = 0;
          startHandleY = 0;
        };
      },
    );
  }

  String getDefaultText(SlotSelection slot) {
    var duration = (Duration(minutes: slot.durationInMinutes));
    var start = slot.startDateTime;
    var end = start.add(duration);
    var startText = "${start.hour.toTimeText()}:${start.minute.toTimeText()}";
    var endText = "${end.hour.toTimeText()}:${end.minute.toTimeText()}";
    var remainedMinutes = slot.durationInMinutes % 60;
    var durationText = (duration.inHours >= 1 ? "${duration.inHours}h " : "") +
        (remainedMinutes != 0 ? "${remainedMinutes}m " : "");
    return "$startText - $endText\n$durationText";
  }
}
