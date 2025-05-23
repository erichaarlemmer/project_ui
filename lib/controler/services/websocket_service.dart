import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project_ui/controler/utils/config_control.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketService {
  final String url;
  late WebSocketChannel _channel;
  late StreamController<Map<String, dynamic>> _controller;
  Timer? _pingTimer;

  WebSocketService(this.url) {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
  }

  void connectAndStartPing() {
    _channel = HtmlWebSocketChannel.connect(url);

    _channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      _controller.add(decoded);
    }, onDone: () {
      debugPrint("WebSocket connection closed.");
    }, onError: (e) {
      debugPrint("WebSocket error: $e");
    });

    // Send startup message
    send({
      "type": "startup",
      "client_id": clientId,
    });

    // Start periodic ping
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      send({"type": "ping"});
    });
  }

  void send(Map<String, dynamic> data) {
    try {
      if (_channel.closeCode == null) {
        _channel.sink.add(jsonEncode(data));
      } else {
        debugPrint("WebSocket is closed. Cannot send: $data");
      }
    } catch (e, stack) {
      debugPrint("Error sending WebSocket data: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  void dispose() {
    _pingTimer?.cancel();
    _channel.sink.close();
    _controller.close();
  }
}
