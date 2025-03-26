import 'package:flutter/material.dart';

class PlateField extends StatelessWidget {
  final String plateText;
  final VoidCallback onDelete; // Add a callback for the delete action

  const PlateField({super.key, required this.plateText, required this.onDelete}); // Pass onDelete to the constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 540,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row( // Use a Row to arrange text and delete button side by side
        children: [
          Expanded(
            child: Center(
              child: Text(
                plateText,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.backspace, color: Colors.black, size: 40), // Delete icon
            onPressed: onDelete, // Trigger delete when clicked
          ),
        ],
      ),
    );
  }
}
