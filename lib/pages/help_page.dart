import 'package:flutter/material.dart';
import 'package:project_ui/widgets/big_button.dart';

class HelpPage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final List<int> prices;
  final List<int> durations;

  const HelpPage({
    super.key,
    required this.onButtonPressed,
    required this.prices,
    required this.durations,
  });

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
    double price = cents / 100;
    return "${price.toStringAsFixed(2)}€";
  }

  @override
  Widget build(BuildContext context) {
    // List to hold the formatted price and duration information
    List<String> priceDurationInfo = [];

    for (int i = 0; i < durations.length - 1; i++) {
      String formattedDuration =
          "${_formatIntMinutes(durations[i])} - ${_formatIntMinutes(durations[i + 1])}";

      String formattedPrice;
      if (prices[i] == 0 && prices[i + 1] == 0) {
        formattedPrice = "Free";
      } else {
        formattedPrice =
            "From ${_formatPrice(prices[i])} to ${_formatPrice(prices[i + 1])}";
      }
      priceDurationInfo.add("• $formattedDuration: $formattedPrice");
    }

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onButtonPressed("home")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: const [
            Icon(Icons.arrow_back, color: Colors.white, size: 56),
            SizedBox(width: 8),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: 56)),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Price information',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to left
                  mainAxisSize: MainAxisSize.min,
                  children:
                      priceDurationInfo.map((info) {
                        return Text(
                          info,
                          style: TextStyle(fontSize: 24),
                          textAlign:
                              TextAlign.left, // Align text itself to left
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
