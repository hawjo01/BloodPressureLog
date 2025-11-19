import 'package:fl_chart/fl_chart.dart';

class FlChartUtils {

  static int findMaxY(List<FlSpot> spots) {
    double maxY = spots.isNotEmpty ? spots.first.y : 0;
    for (var spot in spots) {
      if (spot.y > maxY) {
        maxY = spot.y;
      }
    }
    return maxY.ceil();
  }

  static int findMinY(List<FlSpot> spots) {
    double minY = spots.isNotEmpty ? spots.first.y : 0;
    for (var spot in spots) {
      if (spot.y < minY) {
        minY = spot.y;
      }
    }
    return minY.floor();
  }
}