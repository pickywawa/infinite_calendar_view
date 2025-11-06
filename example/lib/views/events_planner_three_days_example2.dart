import 'package:example/utils.dart';
import 'package:example/views/widgets/event.dart';
import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:intl/intl.dart' as intl;

import '../data.dart';

class PlannerTreeDaysSlot extends StatefulWidget {
  const PlannerTreeDaysSlot({
    super.key,
  });

  @override
  State<PlannerTreeDaysSlot> createState() => _PlannerTreeDaysSlotState();
}

class _PlannerTreeDaysSlotState extends State<PlannerTreeDaysSlot> {
  final EventsController controller = EventsController();
  final TextEditingController _titleController = TextEditingController();
  PersistentBottomSheetController? _bottomSheetController = null;

  @override
  void initState() {
    super.initState();
    controller.updateCalendarData((calendarData) {
      calendarData.addEvents(reservationsEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightPerMinute = 1.3;
    var initialVerticalScrollOffset = heightPerMinute * 7 * 60;

    return EventsPlanner(
      controller: controller,
      daysShowed: 3,
      heightPerMinute: heightPerMinute,
      initialVerticalScrollOffset: initialVerticalScrollOffset,
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: true,
        dayHeaderTextBuilder: (day) => intl.DateFormat("E d").format(day),
      ),
      fullDayParam: FullDayParam(
        fullDayEventsBarVisibility: false,
      ),
      daySeparationWidth: 0,
      dayParam: DayParam(
        onSlotMinutesRound: 60,
        onSlotRoundAlwaysBefore: true,
        dayCustomPainter: (heightPerMinute, isToday) =>
            getGridPainter(heightPerMinute, isToday, context),
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return CustomEventWidgetExample(controller, event, height, width);
        },
        slotSelectionParam: SlotSelectionParam(
          enableTapSlotSelection: true,
          enableLongPressSlotSelection: true,
          enableSlotSelectionResize: false,
          onSlotSelectionTap: (s) {
            showSnack(context, "${s.startDateTime} : ${s.durationInMinutes}");
          },
          onSlotSelectionChange: (slot) {
            if (slot == null) {
              _bottomSheetController?.close();
            } else if (_bottomSheetController == null) {
              _openBottomSheet(slot);
            }
          },
        ),
      ),
    );
  }

  LinesPainter getGridPainter(
    double heightPerMinute,
    bool isToday,
    BuildContext context,
  ) {
    return LinesPainter(
      heightPerMinute: heightPerMinute,
      isToday: isToday,
      lineColor: Colors.grey,
      verticalStrokeWidth: 0.3,
      hourStrokeWidth: 0.3,
      drawQuarterHour: false,
      drawHalfHour: false,
      drawVerticalLeftLine: true,
      slotPainter: TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.add.codePoint),
          style: TextStyle(
            fontSize: 15,
            fontFamily: Icons.add.fontFamily,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }

  void _openBottomSheet(SlotSelection slot) {
    final scaffoldState = Scaffold.of(context);
    _bottomSheetController = scaffoldState.showBottomSheet(
      enableDrag: true,
      (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;

        return Container(
          height: screenHeight / 4,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _bottomSheetController?.close();
                    },
                  ),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      final title = _titleController.text.trim();
                      controller.updateCalendarData((calendarData) {
                        calendarData.addEvents([
                          Event(
                            startTime: slot.startDateTime,
                            endTime: slot.startDateTime
                                .add(Duration(minutes: slot.durationInMinutes)),
                            title: title,
                            color: Colors.blue,
                          )
                        ]);
                      });
                      _bottomSheetController?.close();
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Add a title',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(getSlotText(slot)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    _bottomSheetController!.closed.then((_) {
      setState(() {
        _bottomSheetController = null;
      });
      controller.changeSlotSelection(null);
    });
  }

  String getSlotText(SlotSelection slot) {
    var day = intl.DateFormat("E d").format(slot.startDateTime);
    var startHour = intl.DateFormat('Hm').format(slot.startDateTime);
    var endHour = intl.DateFormat('Hm').format(
        slot.startDateTime.add(Duration(minutes: slot.durationInMinutes)));
    return "$day . $startHour - $endHour";
  }
}
