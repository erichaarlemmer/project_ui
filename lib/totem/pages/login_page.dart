import 'package:flutter/material.dart';
import 'package:project_ui/totem/utils/config_totem.dart';
import 'package:project_ui/totem/widgets/big_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginPage extends StatelessWidget {
  final Function(String) onNavButtonPressed;

  const LoginPage({super.key, required this.onNavButtonPressed});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onNavButtonPressed("home")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: ((100/1080) * screenHeight)),
            const SizedBox(width: 16),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: ((100/1080) * screenHeight))),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please scan the QR code to log in:',
                style: TextStyle(fontSize: ((84/1080) * screenHeight), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: ((40/1080) * screenHeight),
              ), // Adds space between the text and the QR code
              QrImage(
                data:
                    '$httpServerAddress/auth/login/$totemId', // Replace with the data you want to encode in the QR code
                size:
                    MediaQuery.of(context).size.height / 1.5
                    , // Size of the QR code
              ),
            ],
          ),
        ),
      ],
    );
  }
}
