import 'package:flutter/material.dart';

import '../models/plate_control_response.dart';
import '../widgets/big_button.dart';

class PlateDetailsScreen extends StatelessWidget {
  static const routeName = '/plate_details';

  final PlateControlResponse response;

  const PlateDetailsScreen({
    super.key,
    required this.response,
  });

  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildTicketInfo() {
    if (response.ticketInfo == null) {
      return const Text('No valid ticket found.');
    }
    final start = response.ticketInfo!.start;
    final end = response.ticketInfo!.end;
    return Text(
      'Ticket valid from:\n${start.toLocal()}\nto\n${end.toLocal()}',
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTimestampList(String title, List<DateTime> list) {
    if (list.isEmpty) {
      return Text('No $title.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...list.map((dt) => Text(dt.toLocal().toString())).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Parking name: ${response.parkingName}',
                      style: TextStyle(
                          fontSize: ((40 / 1080) * screenHeight),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildTicketInfo(),
                    const SizedBox(height: 20),
                    _buildTimestampList('Last Fines:', response.lastFines),
                    const SizedBox(height: 20),
                    _buildTimestampList('Last Chalks:', response.lastChalks),
                  ],
                ),
              ),
            ),
          ),
          BigButton(
            onButtonPressed: () => _goBack(context),
            isLeft: true,
            isBottom: true,
            isCircle: true,
            color: Colors.redAccent,
            children: const [Icon(Icons.arrow_back)],
          ),
        ],
      ),
    );
  }
}

class PlateDetailsScreenArgs {
  final PlateControlResponse response;

  PlateDetailsScreenArgs({
    required this.response,
  });
}
