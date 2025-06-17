import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_ui/controler/screens/QrLoginScreen.dart';
import 'package:project_ui/controler/widgets/big_button.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'admin_placeholder_screen.dart';
import 'control_screen.dart';
import '../services/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _wsSubscription;
  bool _isInitialized = false;
  late WebSocketService _wsService; // ✅ Cached instance

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;
    _isInitialized = true;

    _wsService = Provider.of<WebSocketService>(context, listen: false);

    _wsSubscription = _wsService.messages.listen(_handleMessage);
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (!mounted) return; // ✅ Avoid acting on disposed widget

    if (message['type'] == 'login') {
      final user = User.fromJson(message);
      final userProvider = context.read<UserProvider>();
      userProvider.setUser(user);

      if (user.group == 'controller') {
        Navigator.of(context).pushNamed(
          ControlScreen.routeName,
          arguments: _wsService,
        );
      } else if (user.group == 'customer_admin' ||
          user.group == 'system_admin') {
        Navigator.of(context).pushNamed(
          AdminPlaceholderScreen.routeName,
          arguments: _wsService,
        );
      }
    }
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
          child: Text(
            'Scan Badge or login...',
            style: TextStyle(
              fontSize: (72 / 1080) * screenHeight,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        BigButton(
          onButtonPressed: () {
            Navigator.of(context).pushNamed(QrLoginScreen.routeName);
          },
          isLeft: true,
          isBottom: false,
          isCircle: false,
          color: Colors.grey,
          children: [
            Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.login,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
          ],
        ),
      ],
    );
  }
}
