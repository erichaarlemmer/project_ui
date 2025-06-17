import 'package:flutter/material.dart';

import '../models/plate_control_response.dart';
import '../widgets/big_button.dart';

class PlateDetailsScreen extends StatelessWidget {
  static const routeName = '/plate_details';

  final PlateControlResponse response;

  const PlateDetailsScreen({super.key, required this.response});

  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final ticket = response.ticketInfo;

    final bool hasTicket = ticket != null && ticket.end.millisecondsSinceEpoch != 0;

    final List<String> fines = response.lastFines
        .take(3)
        .map((dt) => dt.toLocal().toString())
        .toList();

    final List<String> chalks = response.lastChalks
        .take(3)
        .map((dt) => dt.toLocal().toString())
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Ticket info',
                        style: TextStyle(
                          fontSize: ((50 / 1080) * screenHeight),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      hasTicket
                          ? 'Ticket validity from ${ticket.start.toLocal()} to ${ticket.end.toLocal()}'
                          : 'There is no ticket for this car.',
                      style: TextStyle(fontSize: ((40 / 1080) * screenHeight)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Last fines: ${fines.isEmpty ? 'None' : fines.join(', ')}',
                      style: TextStyle(fontSize: ((40 / 1080) * screenHeight)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Last chalks: ${chalks.isEmpty ? 'None' : chalks.join(', ')}',
                      style: TextStyle(fontSize: ((40 / 1080) * screenHeight)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Parking name: ${response.parkingName}',
                      style: TextStyle(fontSize: ((40 / 1080) * screenHeight)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BigButton(
            onButtonPressed: () => _goBack(context),
            isLeft: true,
            isBottom: true,
            isCircle: false,
            color: Colors.redAccent,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: ((100 / 1080) * screenHeight),
              ),
              const SizedBox(width: 8),
              Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ((100 / 1080) * screenHeight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class PlateDetailsScreenArgs {
  final PlateControlResponse response;

  PlateDetailsScreenArgs({required this.response});
}
