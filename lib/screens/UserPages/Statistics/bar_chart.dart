import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatefulWidget {
  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<double> weekHours = [0, 0, 0, 0, 0, 0, 0];
  bool loading = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    hourOfTheDay();
    print("initializing");
  }

  @override
  Widget build(BuildContext context) {
    return loading ? BarChart(InitData()) : BarChart(BarData());
  }

  BarChartData BarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          )),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getAxisTitles,
              reservedSize: 45,
            ),
          )),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  Widget getAxisTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 9,
    );
    Widget text;
    text = Text(value.toInt().toString(), style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y : y,
          color: isTouched ? Colors.white : Colors.cyanAccent,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.cyan, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: listEquals(weekHours, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]) ? 200 : (weekHours.reduce((value, element) => value > element ? value : element) / 10).ceilToDouble() * 10,
            color: Colors.blueGrey[400]!.withOpacity(0.5),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );

  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, weekHours[0], isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, weekHours[1], isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, weekHours[2], isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, weekHours[3], isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, weekHours[4], isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, weekHours[5], isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, weekHours[6], isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  Future<void> hourOfTheDay() async {
    DateTime date = DateTime.now();
    int currDay = date.weekday; //Monday -> 1
    int fromCurrToMon = currDay - 1;
    DateTime monday = date.subtract(Duration(days: fromCurrToMon));

    for (int i = 0; i < 7; i++) {
      DateTime thisDay = monday.add(Duration(days: i));
      String date =
          "${thisDay.year}-${thisDay.month.toString().padLeft(2, '0')}-${thisDay.day.toString().padLeft(2, '0')}";
      if (!mounted) return;
      await DatabaseServices().getTimeOfTheDay(user!.uid, date).then((value) {
        weekHours[i] = value.roundToDouble();
      });
    }
    setState(() {
      loading = false;
    });
  }

  BarChartData InitData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          )),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getAxisTitles,
              reservedSize: 45,
            ),
          )),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 0);
          case 1:
            return makeGroupData(1, 0);
          case 2:
            return makeGroupData(2, 0);
          case 3:
            return makeGroupData(3, 0);
          case 4:
            return makeGroupData(4, 0);
          case 5:
            return makeGroupData(5, 0);
          case 6:
            return makeGroupData(6, 0);
          default:
            return throw Error();
        }
      }),
    );
  }
}
