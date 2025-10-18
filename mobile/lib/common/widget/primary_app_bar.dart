import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common.dart';

class OnboardingAppBar extends StatefulWidget {
  const OnboardingAppBar({super.key, required this.title, required this.currentPoints, this.previousPoints});

  final String title;
  final int currentPoints;
  final int? previousPoints;

  @override
  State<OnboardingAppBar> createState() => _OnboardingAppBarState();
}

class _OnboardingAppBarState extends State<OnboardingAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final int _totalPoints = 120;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);

    final double begin =
        widget.previousPoints != null ? widget.previousPoints!.toDouble() : widget.currentPoints.toDouble();
    final double end = widget.currentPoints.toDouble();

    _progressAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(OnboardingAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPoints != widget.currentPoints) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.currentPoints.toDouble(),
        end: widget.currentPoints.toDouble(),
      ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          ArrowButtonLeft(
            onTap: () {
              if (widget.previousPoints != null) {
                _progressAnimation = Tween<double>(
                  begin: widget.currentPoints.toDouble(),
                  end: widget.previousPoints!.toDouble(),
                ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

                _animationController.reset();
                _animationController.forward().then((_) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    context.pop();
                  });
                });
              } else {
                context.pop();
              }
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return AppProgressBar(
                  totalPoints: _totalPoints,
                  currentPoints: _progressAnimation.value.toInt(),
                  height: 16,
                  backgroundColor: lightGreyColor,
                  progressColor: orangeColor,
                );
              },
            ),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 28),
        centerTitle: true,
        title: Text(widget.title, style: pageHeaderStyle, textAlign: TextAlign.center),
      ),
    );
  }
}
