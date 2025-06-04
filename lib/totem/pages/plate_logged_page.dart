import 'package:flutter/material.dart';
import 'package:project_ui/totem/widgets/big_button.dart';

class SelectionPage extends StatefulWidget {
  final List<String> options;
  final Function(String) onNavButtonPressed;
  final Function(String) setPlate;

  const SelectionPage({
    super.key,
    required this.onNavButtonPressed,
    required this.options,
    required this.setPlate,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    if (widget.options.isNotEmpty) {
      setState(() {
        _selectedOption = widget.options[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Center dropdown in the screen

        // Back button
        BigButton(
          onButtonPressed: () => widget.onNavButtonPressed("home"),
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
            SizedBox(width: 8),
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
          ],
        ),

        // Next button
        BigButton(
          onButtonPressed: () {
            widget.setPlate(_selectedOption!);
            widget.onNavButtonPressed("duration");
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Next",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((56 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: ((56 / 1080) * screenHeight),
            ),
          ],
        ),

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select your Liscence plate:",
                style: TextStyle(
                  fontSize: ((56 / 1080) * screenHeight),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Transform.scale(
                scale: 1.5, // Increase scale as needed
                child: DropdownButton<String>(
                  value: _selectedOption,
                  iconSize:
                      ((30 / 1080) * screenHeight), // Bigger dropdown arrow
                  style: TextStyle(
                    // Style for selected item
                    fontSize: ((30 / 1080) * screenHeight),
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue;
                    });
                  },
                  items:
                      widget.options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: ((30 / 1080) * screenHeight),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
