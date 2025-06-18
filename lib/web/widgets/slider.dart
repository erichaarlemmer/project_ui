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

  // int _mapSliderToCents(double sliderValue) {
  //   int index = sliderValue.floor();

  //   if (index == widget.priceIntervals.length - 1) {
  //     return widget.priceIntervals[index];
  //   }
  //   int m = widget.priceIntervals[index + 1] - widget.priceIntervals[index];
  //   double price = (sliderValue - index) * m + widget.priceIntervals[index];

  //   return price.toInt();
  // }

  int findIntervalIndex(List<int> intervals, int value) {
    for (int i = 0; i < intervals.length - 1; i++) {
      if (value == intervals[intervals.length - 1]) {
        return intervals.length - 1;
      } else if (value >= intervals[i] && value < intervals[i + 1]) {
        return i;
      }
    }
    return -1; // value is out of bounds (before first or after last interval)
  }

  int _mapMinutesToCents(int duration) {
    if (widget.durationIntervals.last == duration) {
      return widget.priceIntervals.last;
    }

    int index = findIntervalIndex(widget.durationIntervals, duration);

    bool isLastInterval = index == widget.priceIntervals.length - 1;
    if (isLastInterval) {
      return widget.priceIntervals[index];
    }

    int currentPrice = widget.priceIntervals[index];
    int nextPrice = widget.priceIntervals[index + 1];
    double priceDiff = (nextPrice - currentPrice).toDouble();

    if (priceDiff == 0) {
      return currentPrice;
    }

    int currentDuration = widget.durationIntervals[index];
    int nextDuration = widget.durationIntervals[index + 1];
    double durationDiff = (nextDuration - currentDuration).toDouble();

    double slope = priceDiff / durationDiff;
    double base = currentPrice.toDouble();
    double offset = duration - currentDuration.toDouble();

    return (slope * offset + base).ceil();
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
          width: MediaQuery.of(context).size.width * 5 / 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: ((50 / 1080) * screenHeight),
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
                      _mapSliderToMinutes(value),
                      _mapMinutesToCents(_mapSliderToMinutes(value)),
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
                              fontSize: ((60 / 1080) * screenHeight),
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
