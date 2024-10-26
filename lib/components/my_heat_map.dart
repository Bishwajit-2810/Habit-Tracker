import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> dataSet;
  final DateTime startDate;
  const MyHeatMap({super.key, required this.startDate, required this.dataSet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: HeatMap(
        endDate: DateTime.now(),
        datasets: dataSet,
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.inversePrimary,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: {
          1: Colors.green.shade100,
          2: Colors.green.shade300,
          3: Colors.green.shade500,
          4: Colors.green.shade600,
          5: Colors.green.shade700,
        },
      ),
    );
  }
}
