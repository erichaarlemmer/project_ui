import 'package:flutter/material.dart';
import 'package:project_ui/totem/utils/config_totem.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:project_ui/controler/widgets/big_button.dart';
import 'package:intl/intl.dart';

class TicketPage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final String plate;
  final int duration;
  final int price;
  final String ticketId;
  final int ticketCreationTime;
  final int ticketEnd;
  final String parkingName;

  const TicketPage({
    super.key,
    required this.onButtonPressed,
    required this.plate,
    required this.duration,
    required this.price,
    required this.ticketId,
    required this.ticketCreationTime,
    required this.ticketEnd,
    required this.parkingName,
  });

  TextStyle _infoTextStyle(double screenHeight) {
    return TextStyle(
      fontSize: (60 / 1080) * screenHeight,
      color: Colors.black87,
    );
  }

  String _formatIntMinutes(int minute) {
    int hours = (minute / 60).floor();
    int min = minute - hours * 60;

    if (hours == 0) {
      return "${min}min";
    } else {
      return "${hours}h ${min.toString().padLeft(2, '0')}min";
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat.Hm().format(date); // HH:mm
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // QR Code on the left
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please scan the QR code to see your receipt:',
                    style: TextStyle(
                      fontSize: ((48 / 1080) * screenHeight),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ((20 / 1080) * screenHeight)),
                  QrImage(
                    data: '$httpServerAddress/api/ticket-view/$ticketId/',
                    size: screenHeight / 1.5,
                  ),
                ],
              ),
              SizedBox(
                width: screenWidth * 0.08,
              ), // spacing between QR and container
              // Ticket Info Container
              Container(
                padding: EdgeInsets.all(24),
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Plate: $plate", style: _infoTextStyle(screenHeight)),
                    Text(
                      "Duration: ${_formatIntMinutes(duration)}",
                      style: _infoTextStyle(screenHeight),
                    ),
                    Text(
                      "Price: ${price / 100}€",
                      style: _infoTextStyle(screenHeight),
                    ),
                    Text(
                      "Created at: ${_formatTime(ticketCreationTime)}",
                      style: _infoTextStyle(screenHeight),
                    ),
                    Text(
                      "Valid until: ${_formatTime(ticketEnd)}",
                      style: _infoTextStyle(screenHeight),
                    ),
                    Text(
                      "Parking: $parkingName",
                      style: _infoTextStyle(screenHeight),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Home Button at the bottom right
        BigButton(
          onButtonPressed: () {
            onButtonPressed("home");
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((100 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: ((16 / 1920) * screenWidth)),
            Icon(
              Icons.home,
              color: Colors.white,
              size: ((100 / 1080) * screenHeight),
            ),
          ],
        ),
      ],
    );
  }
}
