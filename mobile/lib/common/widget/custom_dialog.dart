import 'package:flutter/material.dart';

import '../common.dart';

class AppEmojiDialog extends StatelessWidget {
  const AppEmojiDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    required this.secondaryButtonTitle,
    required this.emoji,
    required this.onTap,
    required this.onSecondaryTap,
  });

  final String title;
  final String subtitle;
  final String buttonTitle;
  final String secondaryButtonTitle;
  final String emoji;
  final Function onTap;
  final Function onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(emoji, style: const TextStyle(fontSize: 70)),
            const SizedBox(height: 20),
            Text(title, style: pageHeaderStyle),
            const SizedBox(height: 20),
            Text(subtitle, style: dialogSubtitleStyle.copyWith(color: subtitleGreyColor), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            AppButton(title: buttonTitle, onTap: () => onTap()),
            const SizedBox(height: 10),
            SecondaryButton(title: secondaryButtonTitle, onPressed: () => onSecondaryTap()),
          ],
        ),
      ),
    );
  }
}
