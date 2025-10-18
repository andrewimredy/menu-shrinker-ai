import 'package:flutter/widgets.dart';

import '../common.dart';

enum LoadingOverlayColorScheme { surface, contrast }

class LoadingOverlayScope extends StatefulWidget {
  const LoadingOverlayScope({required this.child, super.key});

  final Widget child;

  static void start(
    BuildContext context, {
    LoadingOverlayColorScheme colorScheme = LoadingOverlayColorScheme.surface,
    double size = 60,
  }) {
    return context.findAncestorStateOfType<_LoadingOverlayScopeState>()?.start(colorScheme: colorScheme, size: size);
  }

  static bool checkIfLoading(BuildContext context) =>
      context.findAncestorStateOfType<_LoadingOverlayScopeState>()!.isLoading;

  static void stop(BuildContext context) {
    return context.findAncestorStateOfType<_LoadingOverlayScopeState>()?.stop();
  }

  @override
  State<LoadingOverlayScope> createState() => _LoadingOverlayScopeState();
}

class _LoadingOverlayScopeState extends State<LoadingOverlayScope> {
  bool isLoading = false;
  LoadingOverlayColorScheme colorScheme = LoadingOverlayColorScheme.surface;
  double size = 100;

  void start({LoadingOverlayColorScheme colorScheme = LoadingOverlayColorScheme.surface, double size = 100}) {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      this.colorScheme = colorScheme;
      this.size = size;
    });
  }

  void stop() {
    if (!isLoading) return;
    setState(() {
      isLoading = false;
    });
  }

  Color _getBgColor(BuildContext context) {
    switch (colorScheme) {
      case LoadingOverlayColorScheme.surface:
      // return context.colorScheme.inverseSurface.withOpacity(0.65);
      case LoadingOverlayColorScheme.contrast:
        // return context.colorScheme.surface.withOpacity(0.5);
        return blackColor.withAlpha(128);
    }
  }

  AppPumpProgressIndicatorColorScheme _getIndicatorColorScheme(BuildContext context) {
    switch (colorScheme) {
      case LoadingOverlayColorScheme.surface:
        return AppPumpProgressIndicatorColorScheme.surface;
      case LoadingOverlayColorScheme.contrast:
        return AppPumpProgressIndicatorColorScheme.contrast;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (isLoading)
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            color: _getBgColor(context),
            child: AppProgressIndicator(colorScheme: _getIndicatorColorScheme(context), containerSize: size),
          ),
      ],
    );
  }
}
