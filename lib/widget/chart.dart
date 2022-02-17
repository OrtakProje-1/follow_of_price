import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';

class Chart extends StatefulWidget {
  final DateTime month;
  final bool isCurved;
  const Chart({Key? key, required this.month, this.isCurved = false})
      : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  DateTime get month => widget.month;

  @override
  Widget build(BuildContext context) {
    int dayCount = Const.getDayCountFromMonth(month);
    List<Price> allPrices = bloc.getPricesFromMonth(month);
    return LineChart(
      LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xdd37434d),
                strokeWidth: 0.4,
                dashArray: [8],
              );
            }),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: false,
          ),
          // topTitles: SideTitles(
          //   showTitles: true,
          //   getTitles: (s){
          //     return (s+1).toString();
          //   }
          // ),
          topTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) {
              return TextStyle(
                color: bloc.isDarkTheme ? white.withOpacity(0.7) : black,
              );
            },
          ),
          leftTitles: SideTitles(
            showTitles: false
          ),
          rightTitles: SideTitles(
            showTitles: false,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 1,
        maxX: dayCount.toDouble(),
        minY: 0,
        maxY: bloc.getMaxPriceAmount,
        lineTouchData: LineTouchData(
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: barData.colors.first,
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                          radius: 8,
                          color: barData.colors.first,
                          strokeWidth: 1.5,
                          strokeColor: Colors.white.withOpacity(0.5)),
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Const.backgroundColor,
              tooltipRoundedRadius: 8,
              getTooltipItems: (s) {
                int index = s.first.barIndex;
                return s.map((e) {
                  return LineTooltipItem(
                    e.barIndex == index
                        ? Const.dateToString(
                                month.add(Duration(days: (e.x - 1).toInt()))) +
                            "\n-------------\n"
                        : e.y.toString() + " ₺",
                    TextStyle(
                      color: e.barIndex == index
                          ? bloc.isDarkTheme ? white : black
                          : e.barIndex == 0
                              ? primary
                              :bloc.isDarkTheme ? white: Const.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: e.barIndex == index ? e.y.toString() + " ₺" : "",
                        style: TextStyle(
                          fontSize: 12,
                          color: e.barIndex == 0 ? primary :bloc.isDarkTheme ? white : Const.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList();
              }),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: getSpots(true, allPrices),
            isCurved: widget.isCurved,
            colors: [
              primary,
            ],
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            gradientTo: const Offset(0.5, 0),
            gradientFrom: const Offset(0.5, 1),
            belowBarData: BarAreaData(
              colors: [primary.withOpacity(1)],
            ),
          ),
          LineChartBarData(
            spots: getSpots(false, allPrices),
            isCurved: widget.isCurved,
            colors: [
              bloc.isDarkTheme ? white : Const.primaryColor,
            ],
            belowBarData: BarAreaData(
              show: true,
              colors: [
                Const.primaryColor.withOpacity(0.1),
              ],
            ),
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> getSpots(bool isExpenses, List<Price> allPrices) {
    List<MapEntry<int, double>> entry =
        Const.getPricesSorted(month, allPrices, isExpenses: isExpenses)
            .asMap()
            .entries
            .toList();

    List<FlSpot> spots = entry.map((e) {
      return FlSpot((e.key + 1).toDouble(), e.value);
    }).toList();
    return spots;
  }
}
