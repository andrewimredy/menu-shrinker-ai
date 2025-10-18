import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = now.copyWith(day: now.day + 1);
    return tomorrow.year == year &&
        tomorrow.month == month &&
        tomorrow.day == day;
  }

  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.copyWith(day: now.day - 1);
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;
  }

  bool isSameMonth(DateTime dateTime) {
    return dateTime.year == year && dateTime.month == month;
  }
}

class FormatUtils {
  static DateTime dateTimeFromStringTimestamp(dynamic timestamp) =>
      DateTime.parse(timestamp.toString());

  static DateTime returnDateTime(DateTime dateTime) => dateTime;

  static String dateMonthAndDay(DateTime dateTime) {
    final String? closeDay = _closeDay(dateTime);
    return closeDay ?? DateFormat('MM/dd').format(dateTime);
  }

  static String timeFromNow(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    if (difference.inHours >= 24) {
      if (dateTime.isYesterday) {
        return 'yesterday'.tr();
      }
      final int days = difference.inDays;
      if (days < 30) {
        return 'days'.tr(args: [days.toString()]);
      }
      final int month = days ~/ 30;
      if (month < 12) {
        return 'months'.tr(args: [month.toString()]);
      }
      final int years = days ~/ 365;
      return 'years'.tr(args: [years.toString()]);
    }
    final int minutes = difference.inMinutes;
    if (minutes < 60) {
      if (minutes < 1) {
        return 'just_now'.tr();
      }
      return 'minutes'.tr(args: [minutes.toString()]);
    }
    final int hours = minutes ~/ 60;
    final int restMinutes = minutes % 60;
    final String hoursString = 'hours'.tr(args: [hours.toString()]);
    final String minutesString = restMinutes > 0
        ? ' ${'minutes'.tr(args: [
                restMinutes.toString(),
              ])}'
        : '';
    return '$hoursString$minutesString';
  }

  static String? _closeDay(DateTime dateTime) {
    if (dateTime.isToday) {
      return 'today'.tr();
    } else if (dateTime.isTomorrow) {
      return 'tomorrow'.tr();
    } else if (dateTime.isYesterday) {
      return 'yesterday'.tr();
    }
    return null;
  }

  static String dateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String dateString(DateTime dateTime) {
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  static String moneyFormat(double amount) {
    return amount.toStringAsFixed(2);
  }

  static Color darkenColor(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
