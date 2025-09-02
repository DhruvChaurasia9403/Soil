import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { line, bar }

class ChartWidget extends StatelessWidget {
  final ChartType chartType;
  final List<double> temperatureData;
  final List<double> moistureData;

  const ChartWidget({
    super.key,
    required this.chartType,
    required this.temperatureData,
    required this.moistureData,
  });

  @override
  Widget build(BuildContext context) {
    if (chartType == ChartType.line) {
      return LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: temperatureData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.redAccent.withOpacity(0.3),
              ),
            ),
            LineChartBarData(
              spots: moistureData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueAccent.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    } else {
      return BarChart(
        BarChartData(
          barGroups: List.generate(temperatureData.length, (index) {
            return BarChartGroupData(
              x: index,
              // Corrected code
              barRods: [
                BarChartRodData(toY: temperatureData[index], width: 8, color: Colors.redAccent), // Changed to 'toY'
                BarChartRodData(toY: moistureData[index], width: 8, color: Colors.blueAccent),   // Changed to 'toY'
              ],
            );
          }),
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
        ),
      );
    }
  }
}
