![Plugin Banner](https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/main/readme_assets/infinite2.png)

# infinite_calendar_view

[![Build](https://github.com/pickywawa/infinite_calendar_view/workflows/Build/badge.svg?branch=master)](https://github.com/pickywawa/infinite_calendar_view/actions) [![infinite_calendar_view](https://img.shields.io/pub/v/infinite_calendar_view?label=infinite_calendar_view)](https://pub.dev/packages/infinite_calendar_view)

A Flutter Calendar package that allows you to easily implement all calendar UI and calendar views.
Infinite Calendar View is a highly customizable calendar widget for Flutter that supports multiple
calendar layouts.
If this package helps you, consider giving it a 👍 on pub.dev

## Web Demo

<div style="text-align: center;">
<img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/demo-icon.png" alt="drawing" width="100"/>

https://pickywawa.github.io/infinite_calendar_view_demo/
</div>

## Features

- 💙 **Inspired by Outlook and Teams mobile**. Easy to use calendar interface
- 👍 **No external dependencies**. No dependency conflict, easy maintenance
- 🍻 **Three calendar views**. Calendar Planner, Calendar Month and Calendar List views
- ♾️ **Infinite scroll**. Lazy build and best user experience
- 🚀 **Good performance**. With several dozen appointments per day
- ✏️ **All configurable**. Everything is configurable!
- 🌍 **RTL Support (Arabic, Hebrew etc. text/scroll direction)**
- 🗂️ **Events filter**. Easy filter calendar day events
- 🗓️ **Calendar events types**. Managing all-day events and multi-day events. Possibility of having
  several types of events with different placement algorithms
- 🎲 **Customizable number of days**. Depending on the screen size
- 🤏 **Pinch to zoom**. Change the time scale with two fingers or ctrl/cmd + mouse wheel
- 👆🏼 **Drag and drop**. Move calendar appointments easily
- 👆🏼 **Interactive slot selection**. Move appointments easily
- 👩‍👧‍👦 **Multi columns**. Manage multiple calendars in the same calendar view !
- 🗓️ **Events arranger**. Customize the placement of appointments (for each event type) in the
  schedule
- ➕ **many other features**
- 🇫🇷 **Made by Pickywawa with ❤️**

## Showcase

<table style="background-color:rgba(0, 0, 0, 0);">
   <tr>
      <td>
         <div style="text-align:center;">One day</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase1.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Multi days</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase9.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Multi days RTL</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase12.png" alt="drawing" width="220"/>
      </td>
   </tr>
   <tr>
      <td>
         <div style="text-align:center;">List with sticky header</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase7.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Month</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase8.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Month RTL</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase13.png" alt="drawing" width="220"/> 
      </td>
   </tr>
   <tr>
      <td>
         <div style="text-align:center;">Multi Columns - 2 days</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase6.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Columns (multi agendas)</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase5.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Columns other example</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase3.png" alt="drawing" width="170"/> 
      </td>
   </tr>
   <tr>
      <td>
         <div style="text-align:center;">Multi event types</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase4.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Rotated planner (3 days)</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase11.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Rotated planner multi-row</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase10.png" alt="drawing" width="220"/>
      </td>
   </tr>
   <tr>
      <td>
         <div style="text-align:center;">Dark Mode - Planner</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase14.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Dark Mode - List</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase16.png" alt="drawing" width="220"/>
      </td>
      <td>
         <div style="text-align:center;">Interactive slot selection</div>
         <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/showcase15.png" alt="drawing" width="220"/>
      </td>
   </tr>
</table>

## Preview

<table>
   <tr>
      <td colspan="4" style="text-align:center;">
          <div class=""><b>Calendar views</b></div>
      </td>
   </tr>
   <tr>
      <td>
         <div style="text-align:center;"><b>1 day</b></div>
         <div style="text-align:center;">
            <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/one_day.gif" alt="drawing" width="200"/>
         </div>
      </td>
      <td>
         <div style="text-align:center;"><b>3 days</b></div>
         <div style="text-align:center;">
            <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/three_days.gif" alt="drawing" width="200"/>
         </div>
      </td>
      <td>
         <div style="text-align:center;"><b>Month</b></div>
         <div style="text-align:center;">
            <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/month.png" alt="drawing" width="200"/>
         </div>
      </td>
      <td>
         <div style="text-align:center;"><b>List</b></div>
         <div style="text-align:center;">
            <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/events-list.gif" alt="drawing" width="200"/>
         </div>
      </td>
   </tr>
   <tr>
      <td colspan="4">
         <div style="text-align:center;">
            <div style="text-align:center;"><b>7 day (web or tablet)</b></div>
            <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/dark-tablet.png" alt="drawing"  />
         </div>
      </td>
   </tr>
</table>

## Installing

1. Add dependencies to `pubspec.yaml`

   Get the latest version in the 'Installing' tab
   on [pub.dev](https://pub.dev/packages/calendar_view/install)

    ```yaml
    dependencies:
        infinite_calendar_view: <latest-version>
    ```

2. Run pub get.

   ```shell
   flutter pub get
   ```

3. Import package.

    ```dart
    import 'package:infinite_calendar_view/infinite_calendar_view.dart';
    ```

## Implementation

Make sure to check
out [examples](https://github.com/pickywawa/infinite_calendar_view/tree/main/example/lib/views)
and [API docs](https://pub.dev/documentation/infinite_calendar_view/latest/) for more details.

1. Init controller.

   ```dart
    EventsController controller = EventsController();
    ```

2. Add calendar views.

   For 1 Day Calendar Planner View

    ```dart
    Scaffold(
        body: EventsPlanner(
          controller: controller,
          daysShowed : 1
        ),
    );
    ```

   For 3 Days Calendar Planner View

    ```dart
    Scaffold(
        body: EventsPlanner(
          controller: controller,
          daysShowed : 3
        ),
    );
    ```

   For Calendar Month View

    ```dart
    Scaffold(
        body: EventsMonths(
          controller: controller,
        ),
    );
    ```

   For Calendar List View

    ```dart
    Scaffold(
        body: EventsList(
          controller: controller,
        ),
    );
    ```

3. Use `controller` to add or remove events when you want.

   To Add event:

    ```dart
    final event = Event(
       startTime: DateTime(2024, 8, 10, 8, 0),
       endTime: DateTime(2024, 8, 10, 9, 0),
       title: "Event1"
    );

    controller.updateCalendarData((calendarData) {
      calendarData.addEvents([event]);
    });
    ```

   To Add full day event:

    ```dart
    final event = Event(
       isFullDay: true,
       startTime: DateTime(2024, 8, 10),
       title: "Full Day Event"
    );

    controller.updateCalendarData((calendarData) {
      calendarData.addEvents([event]);
    });
   ```

   As soon as you add or remove events from the controller, it will automatically update the
   calendar
   view assigned to that controller.

4. Use `GlobalKey` to jump to a specific date.
   ```dart
    GlobalKey<EventsPlannerState> key = GlobalKey<EventsPlannerState>();
   ```
   Add key in EventsPlanner or EventsList
   ```dart
    EventsPlanner(
      key : key
      ...
    )
   ```
   Jump to date
   ```dart
    key.currentState?.jumpToDate(DateTime(2024, 8, 10))
   ```

## More on the infinite calendar view

1. For Pinch To Zoom
   ```dart
   EventsPlanner(
      controller: controller,
      pinchToZoomParam: PinchToZoomParameters(
         pinchToZoom: true,
         onZoomChange: (heightPerMinute) {},
         pinchToZoomMinHeightPerMinute: 0.5,
         pinchToZoomMaxHeightPerMinute: 2.5,
         pinchToZoomSpeed: 1,
      ),
   );
   ```

2. For Draggable Calendar Event
   ```dart
   EventsPlanner(
      controller: controller,
      dayParam: DayParam(
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return DraggableEventWidget(
            event: event,
            height: height,
            width: width,
            heightPerMinute: heightPerMinute,
            onDragEnd: (exactStartDateTime, exactEndDateTime, roundStartDateTime, roundEndDateTime) {
              moveEvent(event, roundStartDateTime, roundEndDateTime);
            },
            child: DefaultDayEvent(
              height: height,
              width: width,
              title: event.title,
              description: event.description,
            ),
          );
        },
      ),
   );
   ```
   ```dart
   void moveEvent(Event oldEvent, DateTime roundStartDateTime, DateTime roundEndDateTime) {
     controller.updateCalendarData((calendarData) {
       calendarData.updateEvent(
         oldEvent: oldEvent,
         newEvent: oldEvent.copyWith(
           startTime: roundStartDateTime,
           endTime: roundEndDateTime,
         ),
       );
     });
   }
   ```

3. For interactive calendar slot selection

   Active enableTapSlotSelection init slot selection on tap
   Active enableLongPressSlotSelection for draggable slot selection
   Set onSlotMinutesRound for round slot to nearest slot
   ```dart
   EventsPlanner(
      dayParam: DayParam(
        onSlotMinutesRound: 30,
        slotSelectionParam: SlotSelectionParam(
          enableTapSlotSelection: true,
          enableLongPressSlotSelection: true,
        ),
      ),
   )
   ```

4. Manage multiple calendars in the same calendar view with multiple columns

   Set columnIndex in Calendar Event
   ```dart
   Event(
      columnIndex: 2,
      ...
    )
   ```

   Set columns number, labels, colors and ratio (optional)
   ```dart
   EventsPlanner(
      controller: controller,
      columnsParam: ColumnsParam(
        columns: 4,
        columnsLabels: ["Tennis", "Foot", "Bad"],
        columnsWidthRatio: [1 / 3, 1 / 3, 1 / 3],
        columnsColors: [
          Colors.yellow.pastel,
          Colors.green.pastel,
          Colors.blueAccent.pastel,
        ],
      ),
   );
   ```

   <table>
      <tr>
         <td>
             <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/columns1.png" alt="drawing" width="300"/>
         </td>
         <td>
             <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/columns.png" alt="drawing" width="300"/>
         </td>
         <td>
             <img src="https://raw.githubusercontent.com/pickywawa/infinite_calendar_view/master/readme_assets/columns2.png" alt="drawing" width="300"/>
         </td>
      </tr>
   </table>

## All Calendar Parameters

1. Calendar Events Planner all parameters
   ```dart
   EventsPlanner(
      key: GlobalKey<EventsPlannerState>(),
      controller: controller,
      daysShowed: 3,
      initialDate: DateTime.now(),
      maxNextDays: 365,
      maxPreviousDays: 365,
      heightPerMinute: 1.0,
      initialVerticalScrollOffset: 1.0 * 7 * 60,
      daySeparationWidth: 3,
      onDayChange: (firstDay) {},
      onVerticalScrollChange: (offset) {},
      automaticAdjustHorizontalScrollToDay: true,
      onAutomaticAdjustHorizontalScroll: (day) {},
      horizontalScrollPhysics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      dayEventsArranger: SideEventArranger(paddingLeft: 0, paddingRight: 0),
      daysHeaderParam: DaysHeaderParam(
        daysHeaderVisibility: true,
        daysHeaderHeight: 40.0,
        daysHeaderColor: Theme.of(context).appBarTheme.backgroundColor,
        dayHeaderBuilder: (day, isToday) {
          return DefaultDayHeader(
            dayText: DateFormat("E d").format(day),
            isToday: isToday,
            foregroundColor: Colors.white,
          );
        },
      ),
      offTimesParam: OffTimesParam(
        offTimesAllDaysRanges: [
          OffTimeRange(
            TimeOfDay(hour: 0, minute: 0),
            TimeOfDay(hour: 7, minute: 0),
          ),
          OffTimeRange(
            TimeOfDay(hour: 18, minute: 0),
            TimeOfDay(hour: 24, minute: 0),
          )
        ],
        offTimesDayRanges: {
          DateTime(2024, 10, 8): [
            OffTimeRange(
              TimeOfDay(hour: 8, minute: 0),
              TimeOfDay(hour: 18, minute: 0),
            ),
          ],
        },
        offTimesColor: Color(0xFFF4F4F4),
        offTimesAllDaysPainter: (isToday, heightPerMinute, ranges, color) =>
            OffSetAllDaysPainter(
                isToday, heightPerMinute, [], Color(0xFFF4F4F4)),
        offTimesDayPainter: (isToday, heightPerMinute, ranges, color) =>
            OffSetAllDaysPainter(
                isToday, heightPerMinute, [], Color(0xFFF4F4F4)),
      ),
      dayParam: DayParam(
        todayColor: Colors.black12,
        dayTopPadding: 10,
        dayBottomPadding: 15,
        onSlotMinutesRound: 15,
        onSlotTap: (columnIndex, exactDateTime, roundDateTime) {},
        onSlotLongTap: (columnIndex, exactDateTime, roundDateTime) {},
        onSlotDoubleTap: (columnIndex, exactDateTime, roundDateTime) {},
        onDayBuild: (day) {},
        dayEventBuilder: (event, height, width, heightPerMinute) {
          return DefaultDayEvent(
            height: height,
            width: width,
            title: event.title,
            description: event.description,
          );
        },
        dayCustomPainter: (heightPerMinute, isToday) => LinesPainter(
          heightPerMinute: heightPerMinute,
          isToday: isToday,
          lineColor: Colors.black12,
        ),
      ),
      fullDayParam: FullDayParam(
        fullDayEventsBarVisibility: true,
        fullDayEventsBarLeftText: 'All day',
        fullDayEventsBarLeftWidget: Text('All day'),
        fullDayEventsBarHeight: 40,
        fullDayEventsBarDecoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
      ),
      timesIndicatorsParam: TimesIndicatorsParam(
        timesIndicatorsWidth: 60.0,
        timesIndicatorsHorizontalPadding: 4.0,
        timesIndicatorsCustomPainter: (heightPerMinute) => HoursPainter(
          heightPerMinute: 1.0,
          showCurrentHour: true,
          hourColor: Colors.black12,
          halfHourColor: Colors.black12,
          quarterHourColor: Colors.black12,
          currentHourIndicatorColor: Colors.black12,
          halfHourMinHeightPerMinute: 1.3,
          quarterHourMinHeightPerMinute: 2,
        ),
      ),
      currentHourIndicatorParam: CurrentHourIndicatorParam(
        currentHourIndicatorHourVisibility: true,
        currentHourIndicatorLineVisibility: true,
        currentHourIndicatorColor: Colors.blue,
        currentHourIndicatorCustomPainter: (heightPerMinute, isToday) =>
            TimeIndicatorPainter(heightPerMinute, isToday, Colors.blue),
      ),
      pinchToZoomParam: PinchToZoomParameters(
        pinchToZoom: true,
        onZoomChange: (heightPerMinute) {},
        pinchToZoomMinHeightPerMinute: 0.5,
        pinchToZoomMaxHeightPerMinute: 2.5,
        pinchToZoomSpeed: 1,
      ),
      columnsParam: ColumnsParam(
        columns: 2,
        columnsLabels: ["Tennis", "Foot"],
        columnsColors: [Colors.blue, Colors.red],
        columnsForegroundColors: [Colors.white, Colors.white],
        columnsWidthRatio: [1 / 2, 1 / 2],
        columnHeaderBuilder: (day, isToday, columIndex, columnWidth) {
          return DefaultColumnHeader(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            columnText: ["Tennis", "Foot"].elementAt(columIndex),
            columnWidth: columnWidth,
          );
        },
        columnCustomPainter : (double width, int colum) => ColumnPainter(
           width: width,
           columnsParam: columnsParam,
           lineColor: Colors.gray,
        ),
      ),
   );
   ```

2. Calendar Events List all parameters
   ```dart
   EventsList(
      controller: controller,
      initialDate: DateTime.now(),
      maxPreviousDays: 365,
      maxNextDays: 365,
      onDayChange: (day) {},
      todayHeaderColor: const Color(0xFFf4f9fd),
      verticalScrollPhysics: const BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast,
      ),
      dayEventsBuilder: (day, events) {
        return DefaultDayEvents(
          events: events,
          eventBuilder: (event) => DefaultDetailEvent(event: event),
          nullEventsWidget: DefaultDayEvents.defaultEmptyEventsWidget,
          eventSeparator: DefaultDayEvents.defaultEventSeparator,
          emptyEventsWidget: DefaultDayEvents.defaultEmptyEventsWidget,
        );
      },
      dayHeaderBuilder: (day, isToday) => DefaultHeader(
        dayText: DateFormat.MMMMEEEEd().format(day).toUpperCase(),
      ),
   );
   ```

## Local

The package does not support locales itself, so as not to import additional dependencies like intl
which may cause dependency conflicts.

However, all texts are easily customizable. You can use intl to translate the texts into the desired
language.
[Local example](https://github.com/pickywawa/infinite_calendar_view/blob/f0234f435ad3e133c190f5006ac283a22edb2c80/example/lib/views/events_planner_all_params_view.dart#L39C22-L39C32)

## License

```text
MIT License

Copyright (c) 2025 Pickywawa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```

## Tags

calendar, schedule, scheduler, date, planner, planning, timeline, week-view, day-view, multi days,
month-view, events, appointment, booking, calender, calendrier, time, viewer