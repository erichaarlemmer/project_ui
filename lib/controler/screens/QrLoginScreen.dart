import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_ui/controler/utils/config_control.dart';
import 'package:project_ui/controler/widgets/big_button.dart';
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

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan the QR code to log in.',
                style: TextStyle(
                  fontSize: ((40 / 1080) * screenHeight),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              QrImage(
                data: '$httpServerAddress/ctrl/login/$clientId',
                size: screenHeight / 2,
              ),
            ],
          ),
        ),
        BigButton(
          onButtonPressed: () => {Navigator.of(context).pop()},
          isLeft: true,
          isBottom: false,
          isCircle: false,
          color: Colors.grey,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
            SizedBox(width: ((8 / 1080) * screenHeight)),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
