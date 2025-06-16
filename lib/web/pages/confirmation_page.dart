import 'package:flutter/material.dart';
import 'package:project_ui/web/widgets/big_button.dart';

class ConfirmationPage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final String plate;
  final int price;
  final int duration;
  final VoidCallback onTicketCreation;

  const ConfirmationPage({
    super.key,
    required this.plate,
    required this.price,
    required this.duration,
    required this.onButtonPressed,
    required this.onTicketCreation,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onButtonPressed("duration")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: ((100 / 1080) * screenHeight),
            ),
            SizedBox(width: ((16 / 1920) * screenWidth)),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((100 / 1080) * screenHeight),
              ),
            ),
          ],
        ),
        BigButton(
          onButtonPressed: () {
            onTicketCreation();
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Pay Ticket",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((100 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: ((16 / 1920) * screenWidth)),
            Icon(
              Icons.shop_outlined,
              color: Colors.white,
              size: ((100 / 1080) * screenHeight),
            ),
          ],
        ),
        Center(
          child: Container(
            width: (1400 / 1080) * screenHeight,
            padding: EdgeInsets.all(((16 / 1920) * screenWidth)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular((12 / 1080) * screenHeight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: (100 / 1080) * screenHeight,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: (16 / 1080) * screenHeight),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ticket price : ${price / 100}€',
                    style: TextStyle(fontSize: (60 / 1080) * screenHeight),
                  ),
                ),
                SizedBox(height: (8 / 1080) * screenHeight),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Duration of the Ticket: ${_formatIntMinutes(duration)}',
                    style: TextStyle(fontSize: (60 / 1080) * screenHeight),
                  ),
                ),
                SizedBox(height: (8 / 1080) * screenHeight),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Car plate: $plate',
                    style: TextStyle(fontSize: (60 / 1080) * screenHeight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
