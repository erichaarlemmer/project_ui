import 'package:flutter/material.dart';
import 'package:project_ui/web/widgets/big_button.dart';

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
  final TextEditingController _plateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _plateController.addListener(() {
      widget.setPlate(_plateController.text);
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: TextField(
              controller: _plateController,
              decoration: InputDecoration(
                hintText: "Enter your license plate",
                border: InputBorder.none,
                icon: Icon(Icons.directions_car),
              ),
              style: TextStyle(fontSize: ((80 / 1080) * screenHeight)),
            ),
          ),
        ),
        BigButton(
          onButtonPressed: () => widget.onNavButtonPressed("home"),
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: ((100 / 1080) * screenHeight)),
            SizedBox(width: 8),
            Text("Back", style: TextStyle(color: Colors.white, fontSize: ((100 / 1080) * screenHeight))),
          ],
        ),
        BigButton(
          onButtonPressed: () {
            widget.setPlate(_plateController.text);
            widget.onNavButtonPressed("duration");
          },
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text("Next", style: TextStyle(color: Colors.white, fontSize: ((100 / 1080) * screenHeight))),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: ((100 / 1080) * screenHeight)),
          ],
        ),
      ],
    );
  }
}
