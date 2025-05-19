import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plate_control_response.dart';
import '../providers/user_provider.dart';
import '../screens/plate_details_screen.dart';
import '../services/websocket_service.dart';
import '../widgets/big_button.dart';
import '../widgets/keyboard.dart';

class ControlScreen extends StatefulWidget {
  static const routeName = '/control';

  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late WebSocketService wsService;
  String plateInput = '';

  StreamSubscription? _wsSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive WebSocketService from Navigator arguments
    wsService = ModalRoute.of(context)!.settings.arguments as WebSocketService;

    // Subscribe to messages
    _wsSubscription ??= wsService.messages.listen(_handleMessage);
  }

  void _handleMessage(Map<String, dynamic> message) {
    if (message['type'] == 'control_plate') {
      // Parse response and navigate
      final response = PlateControlResponse.fromJson(message);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlateDetailsScreen(
            response: response,
            wsService: wsService,
          ),
        ),
      );
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (plateInput.length < 10) {
        plateInput += key;
      }
    });
  }

  void _clearInput() {
    setState(() {
      plateInput = '';
    });
  }

  void _submit() {
    if (plateInput.isEmpty) return;
    final request = {
      "type": "control_plate",
      "plate": plateInput,
    };
    wsService.send(request);
  }

  void _logout() {
    final userProvider = context.read<UserProvider>();
    userProvider.logout();
    Navigator.of(context).popUntil((route) => route.isFirst);
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
      body: Stack(
        children: [
          Center(
            child: Text(
              plateInput,
              style: TextStyle(
                fontSize: ((150 / 1080) * screenHeight),
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
          ),
          Positioned.fill(
            top: screenHeight * 0.3,
            child: Keyboard(onKeyPress: _onKeyPress),
          ),
          // Back (Logout) Button bottom left
          BigButton(
            onButtonPressed: _logout,
            isLeft: true,
            isBottom: true,
            isCircle: true,
            color: Colors.redAccent,
            children: const [Icon(Icons.arrow_back)],
          ),
          // Clear Button above Back Button
          BigButton(
            onButtonPressed: _clearInput,
            isLeft: true,
            isBottom: false,
            isCircle: false,
            color: Colors.grey,
            children: const [Text('Clear')],
          ),
          // Submit Button bottom right
          BigButton(
            onButtonPressed: _submit,
            isLeft: false,
            isBottom: true,
            isCircle: false,
            color: Colors.green,
            children: const [Text('Submit')],
          ),
        ],
      ),
    );
  }
}
