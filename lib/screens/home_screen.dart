import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/admin_placeholder_screen.dart';
import '../screens/control_screen.dart';
import '../services/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSocketService _wsService;
  StreamSubscription? _wsSubscription;
  String _status = "Waiting for badge scan...";

  @override
  void initState() {
    super.initState();
    // TODO: Replace with your real WebSocket URL
    _wsService = WebSocketService('wss://your-websocket-server-url');

    _wsSubscription = _wsService.messages.listen(_handleMessage);
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (message['type'] == 'login') {
      final user = User.fromJson(message);
      final userProvider = context.read<UserProvider>();
      userProvider.setUser(user);

      if (user.group == 'controler') {
        Navigator.of(context).pushReplacementNamed(ControlScreen.routeName,
            arguments: _wsService);
      } else if (user.group == 'customer_admin' ||
          user.group == 'system_admin') {
        Navigator.of(context).pushReplacementNamed(AdminPlaceholderScreen.routeName,
            arguments: _wsService);
      } else {
        setState(() {
          _status = "Unknown user group: ${user.group}";
        });
      }
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _wsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge Login'),
      ),
      body: Center(
        child: Text(
          _status,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
