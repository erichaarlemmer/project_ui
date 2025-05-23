import 'package:flutter/material.dart';
import 'package:project_ui/controler/services/websocket_service.dart';
import 'package:project_ui/controler/utils/config_control.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    Provider<WebSocketService>(
      create: (_) => WebSocketService(wsServerAddress)..connectAndStartPing(),
      dispose: (_, ws) => ws.dispose(),
      child: const MyApp(),
    ),
  );
}
