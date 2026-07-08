typedef DayWidthBuilder = double Function(DateTime day, double defaultDayWidth);

class DayWidthCalculator {
  DayWidthCalculator({
    required this.getDayFromIndex,
    this.dayWidthBuilder,
    this.defaultDayWidth = 0,
  });

  /// Returns the day associated with a given index (0 = initial day).
  final DateTime Function(int index) getDayFromIndex;

  /// Custom day width builder. If `null`, [defaultDayWidth] is used for
  /// every day (previous fixed behaviour).
  DayWidthBuilder? dayWidthBuilder;

  /// Default (uniform) day width, computed from the available viewport
  /// width (viewport width / daysShowed).
  double defaultDayWidth;

  final Map<int, double> _widthCache = {};
  final Map<int, double> _offsetCache = {0: 0};

  /// Clears cached widths/offsets.
  void clear() {
    _widthCache.clear();
    _offsetCache
      ..clear()
      ..[0] = 0;
  }

  /// Width (in pixels) of the day at [index]. Result is cached.
  double widthForIndex(int index) {
    var cached = _widthCache[index];
    if (cached != null) return cached;

    var builder = dayWidthBuilder;
    var width = builder != null
        ? builder(getDayFromIndex(index), defaultDayWidth)
        : defaultDayWidth;
    _widthCache[index] = width;
    return width;
  }

  /// Cumulative horizontal offset (in pixels) of the start of the day at
  /// [index], relative to the start of day 0.
  double offsetForIndex(int index) {
    var cached = _offsetCache[index];
    if (cached != null) return cached;

    if (index > 0) {
      var i = index - 1;
      while (!_offsetCache.containsKey(i)) {
        i--;
      }
      var offset = _offsetCache[i]!;
      for (var k = i; k < index; k++) {
        offset += widthForIndex(k);
        _offsetCache[k + 1] = offset;
      }
      return offset;
    } else {
      var i = index + 1;
      while (!_offsetCache.containsKey(i)) {
        i++;
      }
      var offset = _offsetCache[i]!;
      for (var k = i; k > index; k--) {
        offset -= widthForIndex(k - 1);
        _offsetCache[k - 1] = offset;
      }
      return offset;
    }
  }

  /// Index of the day containing [offset], i.e. the greatest index so
  /// that `offsetForIndex(index) <= offset`.
  int indexForOffset(double offset) {
    if (offset >= 0) {
      var index = 0;
      while (offsetForIndex(index + 1) <= offset) {
        index++;
      }
      return index;
    } else {
      var index = -1;
      while (offsetForIndex(index) > offset) {
        index--;
      }
      return index;
    }
  }

  /// Index of the day boundary nearest to [offset].
  int nearestIndexForOffset(double offset) {
    var index = indexForOffset(offset);
    var start = offsetForIndex(index);
    var end = offsetForIndex(index + 1);
    return (offset - start) <= (end - offset) ? index : index + 1;
  }
}
