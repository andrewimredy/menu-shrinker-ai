import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.totalPoints,
    required this.currentPoints,
    required this.height,
    required this.backgroundColor,
    required this.progressColor,
  });

  final int totalPoints;
  final int currentPoints;
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final double progress = (currentPoints / totalPoints).clamp(0.0, 1.0);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: progress * constraints.maxWidth,
                height: height,
                decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(10)),
              ),
            ],
          );
        },
      ),
    );
  }
}
