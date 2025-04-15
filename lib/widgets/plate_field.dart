import 'package:flutter/material.dart';

class PlateField extends StatelessWidget {
  final String plateText;
  final VoidCallback onDelete; // Add a callback for the delete action

  const PlateField({
    super.key,
    required this.plateText,
    required this.onDelete,
  }); // Pass onDelete to the constructor

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: ((540/1920) * screenWidth),
      height: ((90/1080) * screenHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: ((5 / 1080) * screenHeight)),
        borderRadius: BorderRadius.circular(((5 / 1080) * screenHeight)),
      ),
      child: Row(
        // Use a Row to arrange text and delete button side by side
        children: [
          Expanded(
            child: Center(
              child: Text(
                plateText,
                style: TextStyle(
                  fontSize: ((50/1080) * screenHeight),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.backspace,
              color: Colors.black,
              size: ((40/1080) * screenHeight),
            ), // Delete icon
            onPressed: onDelete, // Trigger delete when clicked
          ),
        ],
      ),
    );
  }
}
