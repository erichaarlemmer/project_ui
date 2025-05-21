import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final bool isLeft;
  final bool isBottom;
  final bool isCircle;
  final Color color;
  final List<Widget> children;

  const BigButton({
    super.key,
    required this.onButtonPressed,
    required this.isLeft,
    required this.isBottom,
    required this.isCircle,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: isBottom ? ((60 / 1080) * screenHeight) : null,
      top: isBottom ? null : ((30 / 1080) * screenHeight),
      left: isLeft ? ((60 / 1920) * screenWidth) : null,
      right: isLeft ? null : ((60 / 1920) * screenWidth),
      child: ElevatedButton(
        style: isCircle
            ? ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(0),
                minimumSize: Size(
                    ((75 / 1920) * screenWidth), ((75 / 1080) * screenHeight)),
              )
            : ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(((100 / 1920) * screenWidth)),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ((20 / 1920) * screenWidth), vertical: 0),
              ),
        onPressed: onButtonPressed,
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
