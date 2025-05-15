import 'package:flutter/material.dart';
import 'package:project_ui/totem/widgets/big_button.dart';
import 'package:project_ui/totem/widgets/slider.dart';

class DurationPage extends StatefulWidget {
  final Function(String) onNavButtonPressed;
  final String plate;
  final List<int> prices;
  final List<int> durations;
  final Function(int d, int p) setDurationPrice;
  final int currentParkingDuration;

  const DurationPage({
    super.key,
    required this.onNavButtonPressed,
    required this.plate,
    required this.currentParkingDuration,
    required this.prices,
    required this.durations,
    required this.setDurationPrice,
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
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
            SizedBox(width: 8),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
          ],
        ),
        BigButton(
          onButtonPressed: () {
            widget.setDurationPrice(_duration, _price);
            widget.onNavButtonPressed("paye");
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Next",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
          ],
        ),

        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: ((60 / 1080) * screenHeight)),
                child: Text(
                  "Duration Selected : ${_formatIntMinutes(_duration)}    Price : ${_formatPrice(_price)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ((42 / 1080) * screenHeight),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ((60 / 1080) * screenHeight)),
                child: DurationSlider(
                  setDuration: (v, n) => _setDuration(v, n),
                  durationIntervals: widget.durations,
                  priceIntervals: widget.prices,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: ((60 / 1080) * screenHeight)),
                child: Container(
                  width: ((660 / 1920) * screenWidth),
                  height: ((330 / 1080) * screenHeight),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: ((10 / 1080) * screenHeight),
                          ),
                          child: Text(
                            "Current Status : ${widget.plate}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ((42 / 1080) * screenHeight),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ((20 / 1080) * screenHeight),
                      ), // spacing between texts
                      if (widget.currentParkingDuration == 0)
                        Padding(
                          padding: EdgeInsets.only(
                            left: ((20 / 1920) * screenWidth),
                          ),
                          child: Text(
                            "You don't currently have a valid ticket.",
                            style: TextStyle(
                              fontSize: ((32 / 1080) * screenHeight),
                              color: Colors.black,
                            ),
                          ),
                        )
                      else ...[
                        Padding(
                          padding: EdgeInsets.only(
                            left: ((20 / 1920) * screenWidth),
                          ),
                          child: Text(
                            "You have ${widget.currentParkingDuration ~/ 60}h ${(widget.currentParkingDuration % 60).toString().padLeft(2, '0')}min of parking left",
                            style: TextStyle(
                              fontSize: ((32 / 1080) * screenHeight),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: ((20 / 1920) * screenWidth),
                          ),
                          child: Text(
                            "Your ticket is valid until: ${TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: widget.currentParkingDuration))).format(context)}",
                            style: TextStyle(
                              fontSize: ((32 / 1080) * screenHeight),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ],
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
