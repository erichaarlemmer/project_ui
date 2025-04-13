import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_ui/utils/config.dart';
import 'package:project_ui/widgets/big_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class LoginPage extends StatelessWidget {
  final Function(String) onNavButtonPressed;
  final WebSocketChannel channel;

  const LoginPage({super.key, required this.onNavButtonPressed, required this.channel});

  @override
  Widget build(BuildContext context) {
    
    channel.stream.listen((message) {
      final decoded = jsonDecode(message);
      print(decoded);
    });

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onNavButtonPressed("home")},
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
                'Please scan the QR code to log in:',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: 20,
              ), // Adds space between the text and the QR code
              QrImage(
                data:
                    '$httpServerAddress/auth/login/$totemId', // Replace with the data you want to encode in the QR code
                size:
                    MediaQuery.of(context).size.height /
                    2, // Size of the QR code
              ),
            ],
          ),
        ),
      ],
    );
  }
}
