import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000/ws/messages/'), // adjust to your server
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketTest(channel: channel),
    );
  }
}

class WebSocketTest extends StatelessWidget {
  final WebSocketChannel channel;

  WebSocketTest({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Messages')),
      body: Center(
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Text(snapshot.hasData
                ? 'Latest: ${snapshot.data}'
                : 'Waiting for message...');
          },
        ),
      ),
    );
  }
}
