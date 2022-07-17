import 'package:AquaFocus/screens/UserPages/Statistics/pie_chart.dart';
import 'package:AquaFocus/screens/UserPages/Statistics/pie_chart_indicator.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class TasksStats extends StatefulWidget {
  const TasksStats({Key? key}) : super(key: key);

  @override
  State<TasksStats> createState() => _TasksStatsState();
}

class _TasksStatsState extends State<TasksStats> {
  int touchedIndex = -1;
  late List tagList;

  bool loading = true;

  @override
  void initState() {
    loading = true;
    setMap();
    super.initState();
  }

  Future<void> setMap() async {
    await DatabaseServices().getUserTags().then((input) {
      setState(() {
        tagList = input;
        loading = false;
      });
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
      loading
      ? LoadingWidget()
      : SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.7,
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
                                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    child: PieChartWidget()),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Column(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(tagList.length, (index) =>
                                        Column(children: [
                                          Indicator(
                                            color: getColor(tagList[index].color),
                                            text: tagList[index].title,
                                            isSquare: false,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                        ])
                                    ),
                                  ),
                                  Indicator(
                                    color: Colors.grey,
                                    text: 'no tag',
                                    isSquare: false,
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
