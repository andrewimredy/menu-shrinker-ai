import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../common.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = whiteColor,
    this.backgroundColor = primaryColor,
    this.shadowColor = primaryShadowColor,
    this.height = 50,
    this.borderRadius = 16,
    this.depth = 4,
    this.isEnabled = true,
    this.disabledColor = lightGreyColor,
    this.disabledTextColor = buttonGreyColor,
  });

  final VoidCallback? onTap;
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final Color shadowColor;
  final double height;
  final double borderRadius;
  final double depth;
  final bool isEnabled;
  final Color disabledColor;
  final Color disabledTextColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.isEnabled ? widget.depth : 0;
  }

  @override
  void didUpdateWidget(AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnabled != widget.isEnabled) {
      setState(() {
        _position = widget.isEnabled ? widget.depth : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp:
          widget.isEnabled
              ? (_) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await Future.delayed(Duration(milliseconds: 20));
                  if (mounted) {
                    setState(() {
                      _position = widget.depth;
                    });
                    widget.onTap?.call();
                  }
                });
                HapticFeedback.lightImpact();
              }
              : null,
      onTapDown:
          widget.isEnabled
              ? (_) {
                setState(() {
                  _position = 0;
                });
              }
              : null,
      onLongPressDown:
          widget.isEnabled
              ? (_) {
                setState(() {
                  _position = 0;
                });
              }
              : null,
      onLongPressUp:
          widget.isEnabled
              ? () {
                setState(() {
                  _position = widget.depth;
                });
              }
              : null,
      onLongPressCancel:
          widget.isEnabled
              ? () {
                setState(() {
                  _position = widget.depth;
                });
              }
              : null,
      child: SizedBox(
        height: widget.height + widget.depth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isEnabled ? widget.shadowColor : widget.disabledColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: _position,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 40),
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isEnabled ? widget.backgroundColor : widget.disabledColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: smallTextStyle.copyWith(
                      color: widget.isEnabled ? widget.textColor : widget.disabledTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlinedAppButton extends StatefulWidget {
  const OutlinedAppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.backgroundColor = whiteColor,
    this.shadowColor = lightGreyColor,
    this.borderColor = lightGreyColor,
    this.height = 56,
    this.borderRadius = 12,
    this.depth = 3,
    this.borderWidth = 2,
    this.isSelected = false,
    this.selectedBackgroundColor = skyColor,
    this.selectedBorderColor = lightBlueColor,
    this.selectedShadowColor = lightBlueColor,
  });

  final VoidCallback onTap;
  final String title;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;
  final double height;
  final double borderRadius;
  final double depth;
  final double borderWidth;
  final bool isSelected;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedShadowColor;

  @override
  State<OutlinedAppButton> createState() => _OutlinedAppButtonState();
}

class _OutlinedAppButtonState extends State<OutlinedAppButton> {
  double _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.depth;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.isSelected ? widget.selectedBorderColor : widget.borderColor;

    return GestureDetector(
      onTapUp: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 20));
          if (mounted) {
            setState(() {
              _position = widget.depth;
            });
            widget.onTap();
          }
        });
        HapticFeedback.lightImpact();
      },
      onTapDown: (_) {
        setState(() {
          _position = 0;
        });
      },
      onLongPressDown: (_) {
        setState(() {
          _position = 0;
        });
      },
      onLongPressUp: () {
        setState(() {
          _position = widget.depth;
        });
      },
      onLongPressCancel: () {
        setState(() {
          _position = widget.depth;
        });
      },
      child: SizedBox(
        height: widget.height + widget.depth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isSelected ? widget.selectedShadowColor : widget.shadowColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: _position,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 40),
              child: Container(
                padding: EdgeInsets.all(16),
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isSelected ? widget.selectedBackgroundColor : widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: effectiveBorderColor, width: widget.borderWidth),
                ),
                child: Text(
                  widget.title,
                  style: listItemStyle.copyWith(color: widget.isSelected ? primaryShadowColor : blackColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CenterOutlinedAppButton extends StatefulWidget {
  const CenterOutlinedAppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
    this.backgroundColor = whiteColor,
    this.shadowColor = lightGreyColor,
    this.borderColor = lightGreyColor,
    this.height = 56,
    this.borderRadius = 12,
    this.depth = 3,
    this.borderWidth = 2,
    this.isSelected = false,
    this.titleColor = blackColor,
    this.selectedBackgroundColor = skyColor,
    this.selectedBorderColor = lightBlueColor,
    this.selectedShadowColor = lightBlueColor,
  });

  final VoidCallback onTap;
  final String title;
  final String? icon;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;
  final double height;
  final double borderRadius;
  final double depth;
  final double borderWidth;
  final bool isSelected;
  final Color titleColor;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedShadowColor;

  @override
  State<CenterOutlinedAppButton> createState() => _CenterOutlinedAppButtonState();
}

class _CenterOutlinedAppButtonState extends State<CenterOutlinedAppButton> {
  double _position = 0;

  @override
  void initState() {
    super.initState();
    _position = widget.depth;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = widget.isSelected ? widget.selectedBorderColor : widget.borderColor;

    return GestureDetector(
      onTapUp: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 20));
          if (mounted) {
            setState(() {
              _position = widget.depth;
            });
            widget.onTap();
          }
        });
        HapticFeedback.lightImpact();
      },
      onTapDown: (_) {
        setState(() {
          _position = 0;
        });
      },
      onLongPressDown: (_) {
        setState(() {
          _position = 0;
        });
      },
      onLongPressUp: () {
        setState(() {
          _position = widget.depth;
        });
      },
      onLongPressCancel: () {
        setState(() {
          _position = widget.depth;
        });
      },
      child: SizedBox(
        height: widget.height + widget.depth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isSelected ? widget.selectedShadowColor : widget.shadowColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              bottom: _position,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 40),
              child: Container(
                padding: EdgeInsets.all(16),
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.isSelected ? widget.selectedBackgroundColor : widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: effectiveBorderColor, width: widget.borderWidth),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) SvgPicture.asset(widget.icon!),
                    if (widget.icon != null) const SizedBox(width: 12),
                    Text(
                      widget.title,
                      style: listItemStyle.copyWith(color: widget.isSelected ? primaryShadowColor : widget.titleColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.height = 46,
    this.buttonColor = primaryColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final double height;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, height)),
          textStyle: WidgetStateProperty.all(smallTextStyle.copyWith(color: buttonColor)),
          padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}

class ArrowButtonLeft extends StatelessWidget {
  const ArrowButtonLeft({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) {
          onTap!();
        }
      },
      child:
          Platform.isIOS
              ? Icon(Icons.arrow_back_ios, color: buttonGreyColor)
              : Icon(Icons.arrow_back, color: buttonGreyColor),
    );
  }
}
