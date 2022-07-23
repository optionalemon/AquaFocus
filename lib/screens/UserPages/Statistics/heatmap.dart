import 'package:AquaFocus/widgets/loading_widget.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapWidget extends StatefulWidget {
  const HeatMapWidget({Key? key}) : super(key: key);

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  late Map<DateTime, int> mapInput;
  bool loading = true;

  @override
  void initState() {
    loading = true;
    setMap();
    super.initState();
  }

  Future<void> setMap() async {
    await DatabaseServices().heatMapData().then((input) {
      setState(() {
        mapInput = input;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : HeatMapCalendar(
            defaultColor: Colors.transparent,
            textColor: Colors.white,
            weekTextColor: Colors.white70,
            flexible: true,
            colorMode: ColorMode.opacity,
            datasets: mapInput,
            colorsets: {
              1: Color.fromARGB(255, 72, 174, 157),
            },
            showColorTip: true,
            colorTipCount: 5,
          );
  }
}
