import 'package:flutter/material.dart';

class TicketPage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final String plate;
  final int duration;
  final int price;
  final String ticketId;
  final int ticketCreationTime;
  final String parkingName;
  const TicketPage({super.key, required this.onButtonPressed, required this.plate, required this.duration, required this.price, required this.ticketId, required this.ticketCreationTime, required this.parkingName});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}