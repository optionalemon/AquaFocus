import 'package:AquaFocus/model/tags.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/widgets/loading_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({Key? key}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  late List tagList;
  late List percentageList;

  bool loading = true;

  @override
  void initState() {
    loading = true;
    setData();
    super.initState();
  }

  Future<void> setData() async {
    List percentages = [];
    double sum = 0;
    List tags = await DatabaseServices().getUserTags();

    if (tags.isEmpty) {
      sum = 0;
    } else {
      for (Tags tag in tags) {
        double percentage = await DatabaseServices().getPercentageForTag(tag);
        //print('percentage:$percentage');
        percentages.add(percentage);
      }
      sum = percentages.reduce((p, c) => p + c);
    }

    percentages.add(double.parse((100.0 - sum).toStringAsFixed(2)));

    // print('tags:$tags');
    // print('sum:$sum');
    // print('percentages:$percentages');

    setState(() {
      tagList = tags;
      percentageList = percentages;
      loading = false;
    });
  }

  Color getColor(String color) {
    if (color == 'red') {
      return const Color.fromARGB(255, 245, 107, 116);
    } else if (color == "orange") {
      return const Color.fromARGB(255, 244, 167, 111);
    } else if (color == "yellow") {
      return const Color.fromARGB(255, 232, 224, 103);
    } else if (color == "green") {
      return const Color.fromARGB(255, 91, 220, 119);
    } else if (color == "blue") {
      return const Color.fromARGB(255, 84, 164, 234);
    } else if (color == "purple") {
      return const Color.fromARGB(255, 125, 100, 226);
    } else { return Colors.black; }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback:
              (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse
                  .touchedSection!.touchedSectionIndex;
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 5,
          centerSpaceRadius: 45,
          sections: showingSections()),
    );
  }

  List<PieChartSectionData>? showingSections() {
    List<PieChartSectionData> tempList = List.generate(tagList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 70.0 : 65.0;
      return PieChartSectionData(
        color: getColor(tagList[i].color),
        value: double.parse(percentageList[i].toStringAsFixed(2)),
        title: '${double.parse(percentageList[i].toStringAsFixed(2))}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });

    tempList.add(
        PieChartSectionData(
          color: Colors.grey,
          value: double.parse(percentageList[tagList.length].toStringAsFixed(2)),
          title: '${double.parse(percentageList[tagList.length].toStringAsFixed(2))}%',
          radius: 65.0,
          titleStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        )
    );

    return tempList;
  }
}
