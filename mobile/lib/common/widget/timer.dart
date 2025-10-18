import 'dart:async';
import 'package:flutter/material.dart';

import '../common.dart';

class TimerWidget extends StatefulWidget {
  final int initialTimeInSeconds;
  final VoidCallback? onTimerComplete;
  final Function(Duration)? onTimerUpdate;

  const TimerWidget({super.key, required this.initialTimeInSeconds, this.onTimerComplete, this.onTimerUpdate});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late int _remainingSeconds;
  late int _elapsedSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialTimeInSeconds;
    _elapsedSeconds = 0;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _elapsedSeconds++;

          if (widget.onTimerUpdate != null) {
            widget.onTimerUpdate!(Duration(seconds: widget.initialTimeInSeconds - _elapsedSeconds));
          }
        } else {
          _timer.cancel();
          if (widget.onTimerComplete != null) {
            widget.onTimerComplete!();
          }
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatTime(), style: middleTextStyle.copyWith(color: whiteColor));
  }
}
