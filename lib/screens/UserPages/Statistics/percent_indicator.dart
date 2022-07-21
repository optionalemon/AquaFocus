import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PercentIndicatorWidget extends StatefulWidget {
  const PercentIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<PercentIndicatorWidget> createState() => _PercentIndicatorWidgetState();
}

class _PercentIndicatorWidgetState extends State<PercentIndicatorWidget> {
  late double percentCompleted;
  bool loading = true;

  @override
  void initState() {
    loading = true;
    setPercent();
    super.initState();
  }

  Future<void> setPercent() async {
    await DatabaseServices().getPercentageCompleted().then((input) {
      setState(() {
        percentCompleted = input;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : LinearPercentIndicator(
      backgroundColor: Colors.grey.withOpacity(0.7),
      barRadius: Radius.circular(5.0),
      width: MediaQuery.of(context).size.width * 0.78,
      animation: true,
      lineHeight: 30.0,
      animationDuration: 1500,
      percent: percentCompleted / 100,
      center: Text("${percentCompleted}%",
          style: const TextStyle(color: Colors.white)),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.greenAccent.withOpacity(0.7),
    );
  }
}