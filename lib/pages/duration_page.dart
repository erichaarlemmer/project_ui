import 'package:flutter/material.dart';
import 'package:project_ui/widgets/big_button.dart';
import 'package:project_ui/widgets/slider.dart';

class DurationPage extends StatefulWidget {
  final Function(String) onNavButtonPressed;
  final String plate;
  final List<int> prices;
  final List<int> durations;

  const DurationPage({
    super.key,
    required this.onNavButtonPressed,
    required this.plate,
    required this.prices,
    required this.durations,
  });

  @override
  State<DurationPage> createState() => _DurationPageState();
}

class _DurationPageState extends State<DurationPage> {
  int _duration = 0;
  int _price = 0;

  void _setDuration(int minute, int cents) {
    setState(() {
      _duration = minute;
      _price = cents;
    });
  }

  String _formatIntMinutes(int minute) {
    int hours = (minute / 60).floor();
    int min = minute - hours * 60;

    if (hours == 0) {
      return "${min}min";
    } else {
      return "${hours}h ${min.toString().padLeft(2, '0')}min";
    }
  }

  String _formatPrice(int cents) {
    if (cents > 0) {
      double price = cents / 100;
      return "${price.toStringAsFixed(2)}€";
    } else {
      return "Free";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {widget.onNavButtonPressed("plate")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: ((56/1080) * screenHeight)),
            SizedBox(width: 8),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: ((56/1080) * screenHeight))),
          ],
        ),
        BigButton(
          onButtonPressed: () => {widget.onNavButtonPressed("paye")},
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text("Next", style: TextStyle(color: Colors.white, fontSize: ((56/1080) * screenHeight))),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: ((56/1080) * screenHeight)),
          ],
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: ((60/1080) * screenHeight)),
                child: Text(
                  "Duration Selected : ${_formatIntMinutes(_duration)}    Price : ${_formatPrice(_price)}",
                  style: TextStyle(color: Colors.black, fontSize: ((42/1080) * screenHeight)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ((60/1080) * screenHeight)),
                child: DurationSlider(
                  setDuration: (v, n) => _setDuration(v, n),
                  durationIntervals: widget.durations,
                  priceIntervals: widget.prices,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: ((60/1080) * screenHeight)),
                child: Container(
                  width: ((660/1920) * screenWidth),
                  height: ((330/1080) * screenHeight),
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
                        fontSize: ((42/1080) * screenHeight),
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
