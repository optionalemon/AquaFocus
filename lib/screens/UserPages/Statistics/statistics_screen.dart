import 'package:AquaFocus/screens/UserPages/Statistics/bar_chart.dart';
import 'package:AquaFocus/screens/UserPages/Statistics/heatmap.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Statistics"),
          backgroundColor: Color.fromARGB(40, 0, 0, 0),
        ),
        body: Stack(children: [
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
            child: Column(children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Card(
                  margin: EdgeInsets.all(size.height * 0.03),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  color: Colors.cyanAccent[400]!.withOpacity(0.4),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Weekly',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          'Your focus time distribution this week',
                          style: TextStyle(
                            color: Colors.cyan[200],
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BarChartWidget()),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Card(
                  margin: EdgeInsets.all(size.height * 0.03),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  color: Colors.lightBlueAccent.withOpacity(0.4),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget> [
                          const Text(
                            "Monthly",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            'Your focus time distribution by month',
                            style: TextStyle(
                              color: Colors.cyan[200],
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Expanded(
                            child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                                child: HeatMapWidget()),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                        ]
                    ),
                  ),
                ),
              )
            ]
            ),
              )
          )
        ]
        )
    );
  }
}
