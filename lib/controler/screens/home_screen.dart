import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'admin_placeholder_screen.dart';
import 'control_screen.dart';
import '../services/websocket_service.dart';
import '../utils/config_control.dart';

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

    _wsService = WebSocketService(wsServerAddress);

    _wsSubscription = _wsService.messages.listen(_handleMessage);

    // 👇 Send startup message after slight delay to ensure connection is ready
    Future.delayed(Duration(milliseconds: 300), () {
      _wsService.send({"type": "startup", "client_id": clientId});
    });
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (message['type'] == 'login') {
      final user = User.fromJson(message);
      final userProvider = context.read<UserProvider>();
      userProvider.setUser(user);

      if (user.group == 'controler') {
        Navigator.of(
          context,
        ).pushReplacementNamed(ControlScreen.routeName, arguments: _wsService);
      } else if (user.group == 'customer_admin' ||
          user.group == 'system_admin') {
        Navigator.of(context).pushReplacementNamed(
          AdminPlaceholderScreen.routeName,
          arguments: _wsService,
        );
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
      appBar: AppBar(title: const Text('Badge Login')),
      body: Center(child: Text(_status, style: const TextStyle(fontSize: 24))),
    );
  }
}
