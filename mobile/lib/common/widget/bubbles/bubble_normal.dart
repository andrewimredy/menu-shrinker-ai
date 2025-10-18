import 'package:flutter/material.dart';

import '../../common.dart';

const double _bubbleRadius = 16;

/// Basic chat bubble
///
/// The [BorderRadius] can be customized using [bubbleRadius]
///
/// [margin] and [padding] can be used to add space around or within
/// the bubble respectively
///
/// Color can be customized using [color]
///
/// [tail] boolean is used to add or remove a tail accoring to the sender type
///
/// Display message can be changed using [text]
///
/// [text] is the only required parameter
///
/// Message sender can be changed using [isSender]
///
/// [sent], [delivered] and [seen] can be used to display the message state
///
/// The [TextStyle] can be customized using [textStyle]
///
/// [leading] is the widget that's infront of the bubble when [isSender]
/// is false.
///
/// [trailing] is the widget that's at the end of the bubble when [isSender]
/// is true.
///
/// [onTap], [onDoubleTap], [onLongPress] are callbacks used to register tap gestures

class BubbleNormal extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color? color;
  final String text;
  final bool tail;
  final BoxConstraints? constraints;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const BubbleNormal({
    super.key,
    required this.text,
    this.constraints,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.bubbleRadius = _bubbleRadius,
    this.isSender = false,
    this.color,
    this.tail = true,
    this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = color ?? (isSender ? skyColor : whiteColor);
    final cleanedText = text.trimLeft(); //TODO save clean text in database

    return Row(
      children: <Widget>[
        isSender ? const Expanded(child: SizedBox(width: 5)) : leading ?? Container(),
        Container(
          constraints: constraints ?? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          margin: margin,
          padding: padding,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: bubbleColor,
                border: Border.all(color: borderMessageColor, width: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(tail ? (isSender ? bubbleRadius : 4) : bubbleRadius),
                  bottomRight: Radius.circular(tail ? (isSender ? 4 : bubbleRadius) : bubbleRadius),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: messageTextStyle,
                        children: _parseTextWithStyles(inputText: cleanedText, baseStyle: messageTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        isSender ? (trailing ?? Container()) : const Expanded(child: SizedBox(width: 5)),
      ],
    );
  }

  List<TextSpan> _parseTextWithStyles({required String inputText, required TextStyle baseStyle}) {
    final List<TextSpan> spans = [];
    final RegExp pattern = RegExp(r'\*\*(.*?)\*\*|"(.*?)"|(\*.*?\*)');
    int lastMatchEnd = 0;

    for (final match in pattern.allMatches(inputText)) {
      // Add plain text before the match
      if (lastMatchEnd < match.start) {
        spans.add(TextSpan(text: inputText.substring(lastMatchEnd, match.start), style: baseStyle));
      }

      // Handle matched groups
      if (match.group(1) != null) {
        // Thin style for text inside ** **
        spans.add(TextSpan(text: match.group(1), style: baseStyle.copyWith(fontWeight: FontWeight.w300)));
      } else if (match.group(2) != null) {
        // Regular style for text inside ""
        spans.add(TextSpan(text: match.group(2), style: baseStyle));
      } else if (match.group(3) != null) {
        // Preserve text wrapped in * as plain text, removing the *
        final textWithoutAsterisks = match.group(3)!.substring(1, match.group(3)!.length - 1);
        spans.add(TextSpan(text: textWithoutAsterisks, style: baseStyle.copyWith(color: baseStyle.color)));
      }

      // Update last match end position
      lastMatchEnd = match.end;
    }

    // Add remaining plain text after the last match
    if (lastMatchEnd < inputText.length) {
      spans.add(TextSpan(text: inputText.substring(lastMatchEnd), style: baseStyle));
    }

    return spans;
  }
}
