import 'dart:async';

import 'package:flutter/material.dart';
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
  String _status = "Waiting for badge scan...";
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only run once
    if (_isInitialized) return;
    _isInitialized = true;

    final wsService = Provider.of<WebSocketService>(context, listen: false);

    _wsSubscription = wsService.messages.listen(_handleMessage);

    // Future.delayed(const Duration(milliseconds: 300), () {
    //   wsService.send({
    //     "type": "startup",
    //     "client_id": clientId, // Make sure `clientId` is defined globally or injected
    //   });
    // });
  }

  void _handleMessage(Map<String, dynamic> message) {
    final wsService = Provider.of<WebSocketService>(context, listen: false);

    if (message['type'] == 'login') {
      final user = User.fromJson(message);
      final userProvider = context.read<UserProvider>();
      userProvider.setUser(user);

      if (user.group == 'controler') {
        Navigator.of(context).pushReplacementNamed(
          ControlScreen.routeName,
          arguments: wsService,
        );
      } else if (user.group == 'customer_admin' ||
          user.group == 'system_admin') {
        Navigator.of(context).pushReplacementNamed(
          AdminPlaceholderScreen.routeName,
          arguments: wsService,
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
    super.dispose(); // Don't dispose wsService if using Provider — app-wide
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badge Login')),
      body: Center(
        child: Text(
          _status,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
