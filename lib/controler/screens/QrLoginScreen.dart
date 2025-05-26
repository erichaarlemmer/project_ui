import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/websocket_service.dart';
import 'admin_placeholder_screen.dart';
import 'control_screen.dart';

class QrLoginScreen extends StatefulWidget {
  static const routeName = '/qr-login';

  const QrLoginScreen({super.key});

  @override
  State<QrLoginScreen> createState() => _QrLoginScreenState();
}

class _QrLoginScreenState extends State<QrLoginScreen> {
  StreamSubscription? _wsSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final wsService = Provider.of<WebSocketService>(context, listen: false);

    _wsSubscription ??= wsService.messages.listen((message) {
      if (message['type'] == 'login') {
        final user = User.fromJson(message);
        final userProvider = context.read<UserProvider>();
        userProvider.setUser(user);

        if (user.group == 'controler') {
          Navigator.of(
            context,
          ).pushReplacementNamed(ControlScreen.routeName, arguments: wsService);
        } else if (user.group == 'customer_admin' ||
            user.group == 'system_admin') {
          Navigator.of(context).pushReplacementNamed(
            AdminPlaceholderScreen.routeName,
            arguments: wsService,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unknown user group: ${user.group}")),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('QR Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan the QR code to log in.',
              style: TextStyle(
                fontSize: ((40 / 1080) * screenHeight),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            QrImage(
              data:
                  'exemple.com', // Replace with the data you want to encode in the QR code
              size:
                  MediaQuery.of(context).size.height / 2, // Size of the QR code
            ),
          ],
        ),
      ),
    );
  }
}
