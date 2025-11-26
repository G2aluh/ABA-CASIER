import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simulasi_ukk/models/model_warna.dart';

class BarChartSample6 extends StatelessWidget {
  BarChartSample6({super.key});

  final pilateColor = Warna().Merah;
  final quickWorkoutColor = Warna().Ijo;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(
    int x,
    double pilates,
    double quickWorkout,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(fromY: 0, toY: pilates, color: pilateColor, width: 5),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text = switch (value.toInt()) {
      0 => 'JAN',
      1 => 'FEB',
      2 => 'MAR',
      3 => 'APR',
      4 => 'MAY',
      5 => 'JUN',
      6 => 'JUL',
      7 => 'AUG',
      8 => 'SEP',
      9 => 'OCT',
      10 => 'NOV',
      11 => 'DEC',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  // ignore: unused_element
  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: const BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  generateGroupData(0, 2, 3),
                  generateGroupData(1, 2, 5),
                  generateGroupData(2, 1.3, 3.1),
                  generateGroupData(3, 3.1, 4),
                  generateGroupData(4, 0.8, 3.3),
                  generateGroupData(5, 2, 5.6),
                  generateGroupData(6, 1.3, 3.2),
                  generateGroupData(7, 2.3, 3.2),
                  generateGroupData(8, 2, 4.8),
                  generateGroupData(9, 1.2, 3.2),
                  generateGroupData(10, 1, 4.8),
                  generateGroupData(11, 2, 4.4),
                ],
                maxY: 11 + (betweenSpace * 2),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 3.3,
                      color: pilateColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 8,
                      color: quickWorkoutColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
