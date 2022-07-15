import 'package:AquaFocus/screens/UserPages/Statistics/pie_chart.dart';
import 'package:AquaFocus/screens/UserPages/Statistics/pie_chart_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TasksStats extends StatefulWidget {
  const TasksStats({Key? key}) : super(key: key);

  @override
  State<TasksStats> createState() => _TasksStatsState();
}

class _TasksStatsState extends State<TasksStats> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              fit: BoxFit.cover,
            ),
          )),
      SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Card(
                        margin: EdgeInsets.all(size.height * 0.03),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        color: Colors.indigoAccent[100]!.withOpacity(0.4),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text(
                                'Task Management',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Percentage of tasks by tag',
                                style: TextStyle(
                                  color: Colors.cyan[200],
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Expanded(
                                child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: PieChartWidget()),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Indicator(
                                    color: Color(0xff0293ee),
                                    text: 'Tag 1',
                                    isSquare: false,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Colors.indigo,
                                    text: 'Tag 2',
                                    isSquare: false,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Colors.cyan,
                                    text: 'Tag 3',
                                    isSquare: false,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color(0xff13d38e),
                                    text: 'Tag 4',
                                    isSquare: false,
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
              )
          )
      )
    ]);
  }


}
