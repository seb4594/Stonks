import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stonks/Providers/BarData.dart';

class miniChart extends StatefulWidget {
  miniChart(this.stockData);
  final stockData;
  @override
  _miniChartState createState() => _miniChartState();
}

class _miniChartState extends State<miniChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    BarData bars = BarData(timeWindows: widget.stockData);

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
              // color: Color(0xff232d37),
            ),
            child: InkWell(
              child: LineChart(mainData(bars)),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(BarData bars) {
    List<FlSpot> spots(BarData bars) {
      List<FlSpot> tempSpots = [];
      double foo = 0.0;

      bars.timeWindows.forEach((point) {
        if (foo < 34) tempSpots.add(FlSpot(foo, point['c'] + 0.0));
        foo++;
      });
      // print(tempSpots);
      return tempSpots;
    }

    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      backgroundColor: Colors.white,
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      // minX: 0,
      // maxX: 11,
      minY: bars.low(),
      maxY: bars.high(),
      minX: 0,
      maxX: 35,
      // minY: 0,
      // maxY: 18,
      lineBarsData: [
        LineChartBarData(
          spots: spots(bars),

          //     [
          //   FlSpot(0, 3),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
          isCurved: false,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
