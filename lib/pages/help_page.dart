import 'package:flutter/material.dart';
import 'package:project_ui/widgets/big_button.dart';

class HelpPage extends StatelessWidget {
  final Function(String) onButtonPressed;

  const HelpPage({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
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
                'Tarification Information',
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
                child: Text(
                  '• 0min - 30min: Free\n'
                  '• 30min - 1h: 3€ - 6€\n  '
                  '• 1h - 2h: 6€ - 10€\n',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
