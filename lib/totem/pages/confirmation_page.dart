import 'package:flutter/material.dart';
import 'package:project_ui/totem/widgets/big_button.dart';

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
              size: ((56 / 1080) * screenHeight),
            ),
            SizedBox(width: ((8 / 1920) * screenWidth)),
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
          onButtonPressed: () {onTicketCreation();},
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Pay Ticket",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: ((8 / 1920) * screenWidth)),
            Icon(
              Icons.shop_outlined,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
          ],
        ),
      ],
    );
  }
}
