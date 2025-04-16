import 'package:flutter/material.dart';

class DurationSlider extends StatefulWidget {
  final Function(int, int) setDuration;
  final List<int> durationIntervals;
  final List<int> priceIntervals;

  const DurationSlider({
    super.key,
    required this.setDuration,
    required this.durationIntervals,
    required this.priceIntervals,
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

  int _mapSliderToCents(double sliderValue) {
    int index = sliderValue.floor();

    if (index == widget.priceIntervals.length - 1) {
      return widget.priceIntervals[index];
    }
    int m = widget.priceIntervals[index + 1] - widget.priceIntervals[index];
    double price = (sliderValue - index) * m + widget.priceIntervals[index];

    return price.toInt();
  }

  int findIntervalIndex(List<int> intervals, int value) {
  for (int i = 0; i < intervals.length - 1; i++) {
    if (value >= intervals[i] && value < intervals[i + 1]) {
      return i;
    }
  }
  return -1; // value is out of bounds (before first or after last interval)
}

  int _mapMinutesToCents(int duration) {
    int n = findIntervalIndex(widget.durationIntervals, duration);
    double m = (widget.priceIntervals[n + 1] - widget.priceIntervals[n]) / (widget.durationIntervals[n + 1] - widget.durationIntervals[n]);
    double p = widget.priceIntervals[n].toDouble();

    return (m*duration + p).toInt();
  }

  String _formatIntMinutes(int minute) {
    int hours = (minute / 60).floor();
    int min = minute - hours * 60;

    if (hours == 0) {
      return "${min}min";
    } else {
      return "${hours}h ${min}min"; // different from other
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: ((25 / 1080) * screenHeight),
                  ),
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
                    widget.setDuration(
                      _mapSliderToMinutes(_sliderValue),
                      _mapMinutesToCents(_mapSliderToMinutes(_sliderValue)),
                    );
                  },
                  min: 0.0,
                  max: widget.durationIntervals.length.toDouble() - 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    widget.durationIntervals
                        .map(
                          (min) => Text(
                            _formatIntMinutes(min),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ((20 / 1080) * screenHeight),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
