import 'dart:js_interop';
import 'package:intl/intl.dart';

import 'date_calculator.dart';

@JSExport()
class AwesomeDateTime {
  static Map<String, dynamic> dateDiff(String fromDate, String toDate) {
    final diff = AgeCalculator.dateDifference(
      fromDate: DateTime.parse(fromDate),
      toDate: DateTime.parse(toDate)
    );
    return diff.toJson();
  }

  late DateTime dateTime;
  late bool tzAware;
  final dtFormat = DateFormat('dd MMM yyyy mm:HH');

  AwesomeDateTime({required String dtString}) {
    dateTime = DateTime.parse(dtString);
    tzAware = dtString.contains("+") || dtString.contains("-");
  }

  String stringify(DateTime dt) {
    return dtFormat.format(dt);
  }

  String toUTCTime() {
    return stringify(dateTime.toUtc());
  }

  String toLocalTime() {
    if (!tzAware) {
      setTimeZone(getLocalOffset());
    }
    return stringify(dateTime.toLocal());
  }

  static String getPadded(int val) {
    return val.toString().padLeft(2, '0');
  }

  void setTimeZone(String tz) {
    var positive = true;
    if(tz.contains("-")) {
      positive = false;
      tz = tz.replaceAll("-", "");
    } else {
      tz = tz.replaceAll("+", "");
    }

    final parts = tz.split(":");

    if(parts.length != 2) {
      throw Exception("Invalid tz");
    }

    final hoursRaw = parts[0];
    final minutesRaw = parts[1];

    try {
      var hours = int.parse(hoursRaw);
      var mins = int.parse(minutesRaw);

      if(hours > 14 || mins > 59 || hours < 0 || mins < 0) {
        throw Exception("Invalid numerical in tz");
      }

      late final String finalHours;
      if(positive) {
        finalHours = "+${getPadded(hours)}";
      } else {
        finalHours = "-${getPadded(hours)}";
      }

      var current = dateTime.toUtc().toIso8601String();
      current = current.replaceAll("Z", "$finalHours:${getPadded(mins)}");
      dateTime = DateTime.parse(current);
      tzAware = true;
    } on FormatException {
      throw Exception("Non numeric values where numerical values should be "
          "in tz");
    }
  }

  String getLocalOffset() {
    final offset = DateTime.now().timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs();
    final minutes = (offset.inMinutes.abs() % 60);

    return '$sign${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }
}