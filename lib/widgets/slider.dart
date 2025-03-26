import 'package:flutter/material.dart';

class DurationSlider extends StatefulWidget {
  final Function(int) setDuration;
  final List<int> durationIntervals;

  const DurationSlider({
    super.key,
    required this.setDuration,
    required this.durationIntervals,
  });

  @override
  State<DurationSlider> createState() => _DurationSliderState();
}

class _DurationSliderState extends State<DurationSlider> {
  double _sliderValue = 0;

  int _mapSliderToMinutes(double sliderValue) {
    int index = sliderValue.floor();

    if (index == widget.durationIntervals.length - 1) {
      return widget.durationIntervals[index];
    }
    int m =
        widget.durationIntervals[index + 1] - widget.durationIntervals[index];
    double duration =
        (sliderValue - index) * m + widget.durationIntervals[index];

    return duration.toInt();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 2 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 25.0),
                ),
                child: Slider(
                  activeColor: const Color.fromARGB(255, 0, 207, 62),
                  inactiveColor: Colors.grey,
                  thumbColor: const Color.fromARGB(255, 0, 141, 7),
                  value: _sliderValue,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                    widget.setDuration(_mapSliderToMinutes(_sliderValue));
                  },
                  min: 0.0,
                  max: widget.durationIntervals.length.toDouble() - 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    widget.durationIntervals
                        .map((min) => Text(_formatIntMinutes(min), style: TextStyle(color: Colors.black, fontSize: 20)))
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
