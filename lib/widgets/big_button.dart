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
    return Positioned(
      bottom: isBottom ? 60 : null,
      top: isBottom ? null : 30,
      left: isLeft ? 60 : null,
      right: isLeft ? null : 60,
      child: ElevatedButton(
        style:
            isCircle
                ? ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(0),
                  minimumSize: Size(75, 75),
                )
                : ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
        onPressed: onButtonPressed,
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
