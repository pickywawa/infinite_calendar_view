import 'package:flutter/material.dart';

enum Mode {
  agenda("List", Icons.list),
  day("One Day", Icons.calendar_view_day_outlined),
  day3("Three days", Icons.view_column),
  day3Draggable("Three days - Draggable events", Icons.view_column),
  day3Slot("Three days with slot", Icons.view_column),
  month("Month", Icons.calendar_month),
  multiColumn("Multi columns 1", Icons.view_column_outlined),
  multiColumn2("Multi columns 2", Icons.view_column_outlined),
  day7("Seven days (web or tablet)", Icons.calendar_view_week),
  day3RTL("Three days RTL (Arabic, Hebrew etc.)", Icons.view_column),
  monthRTL("Month RTL (Arabic, Hebrew etc.)", Icons.calendar_month),
  day3Rotation("Three days horizontal (rotation)", Icons.view_list),
  day3RotationMultiColumn(
      "Three days horizontal (rotation) with multi column", Icons.view_list),
  ;

  const Mode(this.text, this.icon);

  final String text;
  final IconData icon;
}
