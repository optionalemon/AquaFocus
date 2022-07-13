import 'package:AquaFocus/screens/UserPages/Statistics/bar_chart.dart';
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
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  margin: EdgeInsets.all(15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  color: Colors.cyanAccent.withOpacity(0.4),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Focus Time Statistics',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          'How long you focus each day',
                          style: TextStyle(
                            color: Colors.cyan[200],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: BarChartWidget()
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}