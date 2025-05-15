import 'package:flutter/material.dart';

class WirelessPayment extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  const WirelessPayment({
    super.key,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: ((60 / 1080) * screenHeight),
      right: ((60 / 1920) * screenWidth),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular((100 / 1920) * screenWidth),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: (20 / 1920) * screenWidth,
          vertical: 0,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
