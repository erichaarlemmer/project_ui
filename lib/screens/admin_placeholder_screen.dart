import 'package:flutter/material.dart';

import '../services/websocket_service.dart';

class AdminPlaceholderScreen extends StatelessWidget {
  static const routeName = '/admin_placeholder';

  final WebSocketService wsService;

  const AdminPlaceholderScreen({super.key, required this.wsService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Placeholder'),
      ),
      body: const Center(
        child: Text(
          'Admin functionality coming soon.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
