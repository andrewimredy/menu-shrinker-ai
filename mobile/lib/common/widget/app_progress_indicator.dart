import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../common.dart';

enum AppPumpProgressIndicatorColorScheme { surface, contrast }

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    this.size = 100,
    this.containerSize,
    this.colorScheme = AppPumpProgressIndicatorColorScheme.surface,
  });

  const AppProgressIndicator.small({Key? key}) : this(key: key, size: 24);

  /// Size of the indicator
  final double size;

  /// The size of the container. If not set, the container will not be shown.
  final double? containerSize;

  /// Color scheme
  final AppPumpProgressIndicatorColorScheme colorScheme;

  Color _getContainerColor(BuildContext context) {
    switch (colorScheme) {
      case AppPumpProgressIndicatorColorScheme.surface:
      // return context.colorScheme.surface;
      case AppPumpProgressIndicatorColorScheme.contrast:
        return whiteColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicator = Lottie.asset(Assets.animations.loadingAnimation, height: size, width: size);
    if (containerSize == null) {
      return indicator;
    }
    return Container(
      alignment: Alignment.center,
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: _getContainerColor(context).withAlpha(64),
            blurRadius: 25,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
        color: _getContainerColor(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: indicator,
    );
  }
}
