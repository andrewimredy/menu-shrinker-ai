import 'package:flutter/material.dart';

import '../common.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  Brightness get brightness => theme.brightness;

  void startLoadingOverlay({
    LoadingOverlayColorScheme colorScheme = LoadingOverlayColorScheme.surface,
    double size = 100,
  }) {
    LoadingOverlayScope.start(this, colorScheme: colorScheme, size: size);
  }

  void updateLoadingOverlay({
    LoadingOverlayColorScheme colorScheme = LoadingOverlayColorScheme.surface,
    required bool isLoading,
  }) {
    if (isLoading && !this.isLoading) {
      startLoadingOverlay();
    } else if (!isLoading && this.isLoading) {
      stopLoadingOverlay();
    }
  }

  void stopLoadingOverlay() => LoadingOverlayScope.stop(this);

  bool get isLoading => LoadingOverlayScope.checkIfLoading(this);

  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    SnackbarHelper.show(
      context: this,
      message: message,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      duration: duration,
    );
  }

  void showErrorSnack(String message) {
    showSnackBar(message, backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError);
  }

  void showInfoSnack(String message) {
    showSnackBar(message, backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary);
  }

  void showSuccessSnack(String message) {
    showSnackBar(message, backgroundColor: greenColor, foregroundColor: whiteColor);
  }
}
