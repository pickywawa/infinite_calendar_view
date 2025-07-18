import 'package:flutter/material.dart';

import '../../infinite_calendar_view.dart';
import '../utils/extension.dart';

class LinesPainter extends CustomPainter {
  const LinesPainter({
    required this.heightPerMinute,
    required this.isToday,
    required this.lineColor,
    this.hourStrokeWidth = 0.5,
    this.halfStrokeWidth = 0.2,
    this.quarterStrokeWidth = 0.1,
  });

  final double heightPerMinute;
  final bool isToday;
  final Color lineColor;
  final double hourStrokeWidth;
  final double halfStrokeWidth;
  final double quarterStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final cellHeight = heightPerMinute * 60;

    final hourPaint = Paint()
      ..color = lineColor
      ..strokeWidth = hourStrokeWidth;

    final halfHourPaint = Paint()
      ..color = lineColor
      ..strokeWidth = halfStrokeWidth;

    final quarterHourPaint = Paint()
      ..color = lineColor
      ..strokeWidth = quarterStrokeWidth;

    for (var i = 0; i < 24; i++) {
      final hourY = i * cellHeight;
      final halfHourY = hourY + cellHeight / 2;
      canvas.drawLine(Offset(0, hourY), Offset(size.width, hourY), hourPaint);
      canvas.drawLine(
          Offset(0, halfHourY), Offset(size.width, halfHourY), halfHourPaint);

      if (heightPerMinute > 2) {
        final quarterHourY15 = hourY + cellHeight / 4;
        final quarterHourY45 = hourY + (cellHeight / 4) * 3;
        canvas.drawLine(Offset(0, quarterHourY15),
            Offset(size.width, quarterHourY15), quarterHourPaint);
        canvas.drawLine(Offset(0, quarterHourY45),
            Offset(size.width, quarterHourY45), quarterHourPaint);
      }
    }
    // draw 24:00
    canvas.drawLine(Offset(0, 24 * cellHeight),
        Offset(size.width, 24 * cellHeight), hourPaint);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) => false;
}

class TimeIndicatorPainter extends CustomPainter {
  const TimeIndicatorPainter(this.heightPerMinute, this.isToday, this.color);

  final double heightPerMinute;
  final bool isToday;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final currentTime = DateTime.now();

    // draw current time line
    if (isToday) {
      final currentTimePaint = Paint()
        ..color = color
        ..strokeWidth = 0.75;
      final currentTimeLineY =
          heightPerMinute * (currentTime.hour * 60 + currentTime.minute);
      canvas.drawLine(Offset(0, currentTimeLineY),
          Offset(size.width, currentTimeLineY), currentTimePaint);
      canvas.drawCircle(Offset(1, currentTimeLineY), 3, currentTimePaint);
    }
  }

  @override
  bool shouldRepaint(TimeIndicatorPainter oldDelegate) => true;
}

class HoursPainter extends CustomPainter {
  const HoursPainter({
    required this.heightPerMinute,
    this.showCurrentHour = true,
    this.hourColor = Colors.black12,
    this.halfHourColor = Colors.black12,
    this.quarterHourColor = Colors.black12,
    this.currentHourIndicatorColor = Colors.black12,
    this.halfHourMinHeightPerMinute = 1.3,
    this.quarterHourMinHeightPerMinute = 2,
    this.textPainterBuilder,
  });

  final double heightPerMinute;
  final bool showCurrentHour;
  final Color hourColor;
  final Color halfHourColor;
  final Color quarterHourColor;
  final Color currentHourIndicatorColor;
  final double halfHourMinHeightPerMinute;
  final double quarterHourMinHeightPerMinute;
  final TextPainter Function(TimeOfDay time, Color defaultColor)?
      textPainterBuilder;

  @override
  void paint(Canvas canvas, Size size) {
    final cellHeight = heightPerMinute * 60;

    // draw currentHour
    final currentTime = TimeOfDay.now();
    if (showCurrentHour) {
      drawHour(
        canvas,
        size,
        currentTime,
        currentTime.totalMinutes * heightPerMinute,
        currentHourIndicatorColor,
      );
    }

    // draw normal hour
    for (var i = 0; i <= 23; i++) {
      // hour
      final hourY = (i * cellHeight) + 4;
      if (!isHideByCurrentTime(currentTime, hourY)) {
        drawHour(canvas, size, TimeOfDay(hour: i, minute: 0), hourY, hourColor);
      }

      // half
      final halfY = hourY + (cellHeight / 2);
      if (heightPerMinute > halfHourMinHeightPerMinute &&
          !isHideByCurrentTime(currentTime, halfY)) {
        drawHour(
            canvas, size, TimeOfDay(hour: i, minute: 30), halfY, halfHourColor);
      }

      // quart15
      final quarterY15 = hourY + (cellHeight / 4);
      if (heightPerMinute > quarterHourMinHeightPerMinute &&
          !isHideByCurrentTime(currentTime, quarterY15)) {
        drawHour(canvas, size, TimeOfDay(hour: i, minute: 15), quarterY15,
            quarterHourColor);
      }

      // quart45
      final quarterY45 = hourY + (cellHeight / 4) * 3;
      if (heightPerMinute > quarterHourMinHeightPerMinute &&
          !isHideByCurrentTime(currentTime, quarterY45)) {
        drawHour(canvas, size, TimeOfDay(hour: i, minute: 45), quarterY45,
            quarterHourColor);
      }
    }

    // 24:00 hour
    final hourY = (24 * cellHeight) + 4;
    if (!isHideByCurrentTime(currentTime, hourY)) {
      drawHour(canvas, size, const TimeOfDay(hour: 24, minute: 0), hourY, hourColor);
    }
  }

  bool isHideByCurrentTime(TimeOfDay currentTime, double y) {
    return showCurrentHour &&
        ((currentTime.totalMinutes * heightPerMinute) - y).abs() <= 10;
  }

  void drawHour(
    Canvas canvas,
    Size size,
    TimeOfDay time,
    double y,
    Color color,
  ) {
    final textPainter = textPainterBuilder?.call(time, color) ??
        getDefaultTextPainter(time, color);
    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset(0, y));
  }

  TextPainter getDefaultTextPainter(TimeOfDay time, Color color) {
    return TextPainter(
      text: TextSpan(
        text:
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
  }

  @override
  bool shouldRepaint(HoursPainter oldDelegate) => false;
}

class OffSetAllDaysPainter extends CustomPainter {
  const OffSetAllDaysPainter(
    this.isToday,
    this.heightPerMinute,
    this.offTimesRanges,
    this.offTimesColor, {
    this.paintToday = false,
  });

  final bool isToday;
  final bool paintToday;
  final double heightPerMinute;
  final List<OffTimeRange> offTimesRanges;
  final Color offTimesColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (!isToday || paintToday) {
      final paint = Paint()..color = offTimesColor;

      for (final range in offTimesRanges) {
        final startY = range.start.totalMinutes * heightPerMinute;
        final endY = range.end.totalMinutes * heightPerMinute;
        canvas.drawRect(
          Rect.fromPoints(Offset(0, startY), Offset(size.width, endY)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(OffSetAllDaysPainter oldDelegate) => true;
}

class ColumnPainter extends CustomPainter {
  const ColumnPainter({
    required this.width,
    required this.columnsParam,
    required this.lineColor,
  });

  final double width;
  final ColumnsParam columnsParam;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    var columnsTotalWidth = 0.0;
    final paint = Paint()..color = lineColor;
    for (var i = 0; i <= columnsParam.columns; i++) {
      canvas.drawLine(Offset(columnsTotalWidth, 0),
          Offset(columnsTotalWidth, size.height), paint);

      if (i != columnsParam.columns) {
        final columnWidth = columnsParam.getColumSize(width, i);
        columnsTotalWidth += columnWidth;
      }
    }
  }

  @override
  bool shouldRepaint(ColumnPainter oldDelegate) => true;
}
