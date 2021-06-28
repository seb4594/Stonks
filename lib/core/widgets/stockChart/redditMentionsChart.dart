import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stonks/Providers/BarData.dart';

class mentionsChart extends StatefulWidget {
  List mentionsData;
  mentionsChart(this.mentionsData);

  @override
  _mentionsChartState createState() => _mentionsChartState();
}

class _mentionsChartState extends State<mentionsChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16.0 / 6.0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
              // color: Color(0xff232d37),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: LineChart(mainData()),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots() {
      List<FlSpot> tempList = [];
      double foo = 0.0;
      widget.mentionsData.forEach((spot) {
        tempList.add(FlSpot(foo, spot['count'] + 0.0));
        foo++;
      });
      return tempList;
    }

    return LineChartData(
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
          showTitles: true,
          reservedSize: 20,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 10),
          getTitles: (value) {
            List dates = [];
            widget.mentionsData.forEach((spot) {
              dates.add(spot['date']);
            });

            switch (value.toInt()) {
              case 0:
                return dates[0].substring(5, 10);
              case 1:
                return dates[1].substring(5, 10);
              case 2:
                return dates[2].substring(5, 10);
              case 3:
                return dates[3].substring(5, 10);
              case 4:
                return dates[4].substring(5, 10);
              case 5:
                return dates[5].substring(5, 10);
              case 6:
                return dates[6].substring(5, 10);
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            if (value % 2 == 0)
              return value.toString();
            else
              return "";
          },
          reservedSize: 25,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 6,
      // minY: 0,
      // maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots(),
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
