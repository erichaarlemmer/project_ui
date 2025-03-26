import 'package:flutter/material.dart';
import 'package:project_ui/widgets/big_button.dart';
import 'package:project_ui/widgets/slider.dart';

class DurationPage extends StatefulWidget {
  final Function(String) onNavButtonPressed;
  final String plate;
  const DurationPage({
    super.key,
    required this.onNavButtonPressed,
    required this.plate,
  });

  @override
  State<DurationPage> createState() => _DurationPageState();
}

class _DurationPageState extends State<DurationPage> {
  int _duration = 0;

  void _setDuration(int minute) {
    setState(() {
      _duration = minute;
    });
  }

  String _formatIntMinutes(int minute) {
    int hours = (minute / 60).floor();
    int min = minute - hours * 60;

    if (hours == 0) {
      return "${min}min";
    } else {
      return "${hours}h ${min}min";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {widget.onNavButtonPressed("plate")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 56),
            SizedBox(width: 8),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: 56)),
          ],
        ),
        BigButton(
          onButtonPressed: () => {widget.onNavButtonPressed("paye")},
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text("Next", style: TextStyle(color: Colors.white, fontSize: 56)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 56),
          ],
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text("Duration Selected : ${_formatIntMinutes(_duration)}", style: TextStyle(color: Colors.black, fontSize: 42)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: DurationSlider(
                  setDuration: (v) => _setDuration(v),
                  durationIntervals: [0, 10, 60, 120],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Container(
                  width: 660,
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Current Status : ${widget.plate}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
