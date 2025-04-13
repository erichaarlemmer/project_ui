import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse(
      'ws://localhost:8000/ws/messages/',
    ), // Update with your server URL
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Client',
      home: WebSocketClient(channel: channel),
    );
  }
}

class WebSocketClient extends StatefulWidget {
  final WebSocketChannel channel;

  const WebSocketClient({Key? key, required this.channel}) : super(key: key);

  @override
  _WebSocketClientState createState() => _WebSocketClientState();
}

class _WebSocketClientState extends State<WebSocketClient> {
  String _latestMessage = 'Waiting for server message...';
  final TextEditingController _idController = TextEditingController();
  bool _idSent = false;

  @override
  void initState() {
    super.initState();

    // Listen to the stream
    widget.channel.stream.listen((message) {
      final decoded = jsonDecode(message);
      setState(() {
        _latestMessage = decoded['message'] ?? message;
      });
    });
  }

  void _sendClientId() {
    final clientId = _idController.text.trim();
    if (clientId.isNotEmpty) {
      final payload = jsonEncode({"id": clientId});
      widget.channel.sink.add(payload);
      setState(() {
        _idSent = true;
      });
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _idSent ? _buildMessageViewer() : _buildIdInput(),
      ),
    );
  }

  Widget _buildIdInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Enter your Client ID:'),
        TextField(controller: _idController),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _sendClientId, child: Text('Connect')),
      ],
    );
  }

  Widget _buildMessageViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Latest Message:'),
          const SizedBox(height: 12),
          Text(
            _latestMessage,
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
