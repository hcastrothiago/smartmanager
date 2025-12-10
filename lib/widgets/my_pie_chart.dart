import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatelessWidget {
  final double percent; // agora é dinâmico

  const MyPieChart({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final restante = 100 - percent;

    return SizedBox(
      width: 70,
      height: 70,
      child: PieChart(
        PieChartData(
          startDegreeOffset: -90,
          sectionsSpace: 0,
          centerSpaceRadius: 22,
          sections: [
            PieChartSectionData(
              value: percent,
              color: const Color.fromARGB(255, 130, 80, 195),
              radius: 14,
              showTitle: false,
            ),
            PieChartSectionData(
              value: restante,
              color: Colors.grey.shade300,
              radius: 14,
              showTitle: false,
            ),
          ],
        ),
      ),
    );
  }
}
