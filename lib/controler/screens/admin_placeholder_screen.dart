import 'package:flutter/material.dart';

class AdminPlaceholderScreen extends StatelessWidget {
  static const routeName = '/admin_placeholder';


  const AdminPlaceholderScreen({super.key});

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
