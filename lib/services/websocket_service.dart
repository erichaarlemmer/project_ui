import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late final WebSocketChannel _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  WebSocketService(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen((message) {
      try {
        final Map<String, dynamic> decoded = json.decode(message);
        _controller.add(decoded);
      } catch (e) {
        // Ignore or log parsing errors
      }
    }, onDone: () {
      // Handle closed connection if needed
    }, onError: (error) {
      // Handle errors if needed
    });
  }

  void send(Map<String, dynamic> message) {
    final encoded = json.encode(message);
    _channel.sink.add(encoded);
  }

  void dispose() {
    _channel.sink.close();
    _controller.close();
  }
}
