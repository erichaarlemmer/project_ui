import 'package:flutter/material.dart';
import 'package:project_ui/widgets/big_button.dart';
import 'package:project_ui/widgets/keyboard.dart';
import 'package:project_ui/widgets/plate_field.dart';

class EnterPlatePage extends StatefulWidget {
  final Function(String) onNavButtonPressed;
  final Function(String) setPlate;

  const EnterPlatePage({
    super.key,
    required this.onNavButtonPressed,
    required this.setPlate,
  });

  @override
  State<EnterPlatePage> createState() => _EnterPlatePageState();
}

class _EnterPlatePageState extends State<EnterPlatePage> {
  String _currentPlate = "";

  void onKeyPress(String key) {
    setState(() {
      if (key == "del") {
        _currentPlate = _currentPlate.substring(0, _currentPlate.length - 1);
      } else {
        _currentPlate += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "Please type your liscence plate",
              style: TextStyle(color: Colors.black, fontSize: 56),
            ),
          ),
        ),
        BigButton(
          onButtonPressed: () => {widget.onNavButtonPressed("home")},
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 56),
            SizedBox(width: 8),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: 56)),
          ],
        ),
        BigButton(
          onButtonPressed: () {
            widget.setPlate(_currentPlate);
            widget.onNavButtonPressed("duration");
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text("Next", style: TextStyle(color: Colors.white, fontSize: 56)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 56),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: PlateField(
              plateText: _currentPlate,
              onDelete: () => onKeyPress("del"),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Keyboard(onKeyPress: onKeyPress),
        ),
      ],
    );
  }
}
