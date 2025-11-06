## 2.10.2

- [new] Support InteractiveSlot onLongPressEnd
  override https://github.com/pickywawa/infinite_calendar_view/issues/31
- [new] Add grid CustomPainter https://github.com/pickywawa/infinite_calendar_view/issues/29
- [bug] Debug interactive slot resize and can disable resize
- [new] Add slot painter in day painter
- [documentation] add slot grid agenda example

## 2.10.1

- [lint] Clean code
- [bug] RTL : current day on onDayChange/updateFocusedDay is wrong

## 2.10.0

- [bug] due to the change in some locales, some days of the calendar were duplicated

## 2.9.2

- [lint] Revert to 80 chars
- [lint] Use flutter_lints instead of lints
- [lint] Clean code

## 2.9.1

- [documentation] Showcase dark mode and interactive slot selection
- [documentation] Update readme
- [documentation] Add simple example and move app

## 2.9.0

- [lint] Linter 150 chars
- [new] Interactive slot selection
- [new] Round slot date tap or selection to previous hour

## 2.8.2

- [documentation] Add rotated view examples
- [documentation] Showcase
- [lint] Clean warning

## 2.8.1

- [documentation] Showcase
- [lint] Clean warning

## 2.8.0

- [new] RTL support (Arabic, Hindi, Hebrew... text direction)

## 2.7.1

- [bug] onMonthChange send wrong month when scrolling up on EventsMonths with
  automaticAdjustScrollToStartOfMonth =
  true https://github.com/pickywawa/infinite_calendar_view/issues/25

## 2.7.0

- [new] custom top left cell https://github.com/pickywawa/infinite_calendar_view/issues/20
- [new] any number of persons in multi
  column https://github.com/pickywawa/infinite_calendar_view/issues/19

## 2.6.0

- [new] add zoom with ctrl/cmd + mouse
  wheel https://github.com/pickywawa/infinite_calendar_view/issues/17
- [readme] add description + add showcase

## 2.5.5

- [improve] add day parameter into
  dayMoreEventsBuilder https://github.com/pickywawa/infinite_calendar_view/issues/14

## 2.5.4

- [bug] debug jumpToDate in EventsList
- [readme] correction of past modifications
- [demo] use calendar_view in EventsListView example
- [demo] use PageScrollPhysics in EventsPlannerOneDayView example
- [debug] secure removeDayEvents against "Concurrent modification during iteration"

## 2.5.3

- [demo] change image preview, banner and icon

## 2.5.2

- [bug] remove all day event method for multi-days events

## 2.5.1

- [bug] remove all day event method
- [bug] no show quarter and half hour after 24:00

## 2.5.0

- [new] add textPainterBuilder in HoursPainter for easy custom hour text and style
- [change] reverse fullDay events list to be displayed in order
- [bug] debug replaceDayEvents in CalendarData for multi-days events
- [new] add removeDayEvents and removeMultiDayEvent in CalendarData
- [new] add verticalScrollPhysics in EventsPlanner
- [new] add gesture in DefaultDetailEvent
- [new] debug timeText/durationText parameters + change duration default text in DefaultDetailEvent

## 2.4.0

- [new] pinch to zoom in month view
- [new] limit day range : add scroll day min and max offset for planner view
- [change] remove InkWell in default month event for performance issue
- [debug] change DraggableMonthEvent to LongPressDraggable

## 2.3.1

- [bug] debug month event drag and drop local position (for no fullscreen view)

## 2.3.0

- [new] add DraggableMonthEvent for drag and drop month event
- [improve] improve DefaultMonthDayEvent parameters and add InkWell
- [bug] debug removeEvent for multi days events
- [new] add effective StartTime/EndTime in event for preserve initials date for multi days events
- [change] add width and height in month dayEventBuilder

## 2.2.1

- [bug] show column with only one column
- [demo] improve multi column 2 demo

## 2.2.0

- [improve] add colum index to drag and drop for multi-columns
- [improve] add column in slot events https://github.com/pickywawa/infinite_calendar_view/issues/6
- [bug] start of week in month view https://github.com/pickywawa/infinite_calendar_view/issues/7
- [change] remove heightPerMinute in DragEventWidget (no necessary)

## 2.1.0

- [change] add custom round border to DefaultEventWidget with default value = 3
- [change] add column and day in offsetTimes builder
- [improve] paint offsetTimes per columns
- [demo] add on day multi column view, with custom header (avatar) and custom offsetTimes

## 2.0.6

- [bug] no replace multi day events in replaceDayEvents

## 2.0.4

- [bug] https://github.com/pickywawa/infinite_calendar_view/issues/5
- [bug] rename uuid to uniqueId

## 2.0.3

- [demo] month correction

## 2.0.2

- [bug] wheel scroll bug on web
- [bug] pointer scroll support on web
- [bug] drag and drop on calendar not full width
- [improve] change vertical scroll during drag and drop
- [documentation] improve multi column demo
- [documentation] web demo

## 2.0.1

- [improve] Complete Line Painter stroke option
- [documentation] Complete readme

## 2.0.0

- [change] Fusion between Event and fullDayEvent
- [new] New view : infinite month view !
- [new] Multi days events management
    - generate and add unique id in each event
    - multi day events in month view
    - delete and update methode in controller to remove multi day event yet
- [new] Focused day saved in controller
    - easy shared focusedDay between views
    - init one callback (for update AppBar for example)
    - use controller focusedDay by default if intitialDay is not defined
- Add full day event in list details view yet (with fusion between Event and fullDayEvent)
- [improve] Complete DefaultDetailEvent
- [improve] InkWell in DefaultDetailEvent and DefaultDayEvent for beautiful tap
- [improve] Scroll in FullDayEvents for unlimited full day events
- [example] Show month in AppBar
- [example] Month Example
- [example] One Day + Table Calendar Example

## 1.1.5

- Multi days events bug with multi columns

## 1.1.4

- Multi days events management (range)

## 1.1.3

- Readme preview gif

## 1.1.2

- [bug] Event size when pinch to zoom
- [bug] DefaultDayEvent overflow text when pinch to zoom
- [new] First and end line in column painter
- [new] Preview gifs

## 1.1.1

- [bug] Rebuild day list header when day events change
- [new] add tablet screenshot

## 1.1.0

- [new] Multiple column per day
- [new] Add day events in events list builder and rebuild when day events change
- [bug] Sync build of day events /list events when events are already in controller

## 1.0.3

- Add full day event builder
- Bug on full day event default font size
- Add full day event example

## 1.0.2

- Pub dev publish warning corrections

## 1.0.1

- Pub dev publish warning corrections

## 1.0.0

- Initial release
- Updated `README.md` file.
- Added license information in package files.
- Updated project description in `pubspec.yaml`
- Updated documentation.