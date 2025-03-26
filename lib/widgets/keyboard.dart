import 'package:flutter/material.dart';

class KeyButton extends StatelessWidget {
  final String keyLetter;
  final Function(String) onPressed;

  const KeyButton({
    super.key,
    required this.keyLetter,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: ElevatedButton(
        onPressed: () => {onPressed(keyLetter)},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.black, width: 5),
          ),
        ),
        child: Text(
          keyLetter,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final Function(String) onKeyPress;

  const Keyboard({super.key, required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    List<List<String>> azertyFormat = [
      ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      ['A', 'Z', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['Q', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M'],
      ['W', 'X', 'C', 'V', 'B', 'N'],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          azertyFormat.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    row.map((letter) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: KeyButton(
                          keyLetter: letter,
                          onPressed: onKeyPress,
                        ),
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }
}
