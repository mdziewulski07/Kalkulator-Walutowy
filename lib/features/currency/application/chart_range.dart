enum ChartRange {
  d1,
  d3,
  w1,
  m1,
  m3,
  m6,
  y1,
}

extension ChartRangeX on ChartRange {
  Duration get duration {
    switch (this) {
      case ChartRange.d1:
        return const Duration(days: 1);
      case ChartRange.d3:
        return const Duration(days: 3);
      case ChartRange.w1:
        return const Duration(days: 7);
      case ChartRange.m1:
        return const Duration(days: 30);
      case ChartRange.m3:
        return const Duration(days: 90);
      case ChartRange.m6:
        return const Duration(days: 180);
      case ChartRange.y1:
        return const Duration(days: 365);
    }
  }
}
