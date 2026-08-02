
// source: https://github.com/JErazo7/age_calculator/tree/main

class DateDuration {
  int days;
  int months;
  int years;
  int hours;
  int minutes;
  int seconds;

  DateDuration({
    this.days = 0,
    this.months = 0,
    this.years = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });

  @override
  String toString() {
    return 'Years: $years, Months: $months, Days: $days';
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'months': months,
      'years': years,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }
}

/// Age Class
class AgeCalculator {
  /// _daysInMonth cost contains days per months; daysInMonth method to be used instead.
  static const List<int> _daysInMonth = [
    31, // Jan
    28, // Feb, it varies from 28 to 29
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31 // Dec
  ];

  /// isLeapYear method
  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// daysInMonth method
  static int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year))
          ? 29
          : _daysInMonth[month - 1];

  /// dateDifference method
  static DateDuration dateDifference({
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    // Check if toDate to be included in the calculation
    DateTime endDate = toDate;

    int years = endDate.year - fromDate.year;
    int months = 0;
    int days = 0;

    if (fromDate.month > endDate.month) {
      years--;
      months = (DateTime.monthsPerYear + endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years,
            ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else if (endDate.month == fromDate.month) {
      if (fromDate.day > endDate.day) {
        years--;
        months = DateTime.monthsPerYear - 1;
        days = daysInMonth(fromDate.year + years,
            ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else {
      months = (endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years, (fromDate.month + months)) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    }

    // --- Time-of-day component ---
    int hours = endDate.hour - fromDate.hour;
    int minutes = endDate.minute - fromDate.minute;
    int seconds = endDate.second - fromDate.second;

    if (seconds < 0) {
      seconds += 60;
      minutes--;
    }

    if (minutes < 0) {
      minutes += 60;
      hours--;
    }

    if (hours < 0) {
      hours += 24;
      days--;
    }

    // If borrowing a day pushed `days` negative, cascade the borrow back
    // through months/years — same logic pattern as the date-part borrowing
    // above, just triggered by the time component instead of the day component.
    if (days < 0) {
      months--;

      if (months < 0) {
        years--;
        months += DateTime.monthsPerYear;
      }

      // Borrow the number of days in the month that we just moved back into.
      // Mirrors the `daysInMonth(...)` calls used earlier in this function.
      final borrowedMonth =
          ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1;
      final borrowedYear = fromDate.year + years +
          ((fromDate.month + months - 1) ~/ DateTime.monthsPerYear);

      days += daysInMonth(borrowedYear, borrowedMonth);
    }

    return DateDuration(
      days: days,
      months: months,
      years: years,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// add method
  static DateTime add(
      {required DateTime date, required DateDuration duration}) {
    int years = date.year + duration.years;
    years += ((date.month + duration.months) ~/ DateTime.monthsPerYear);
    int months = ((date.month + duration.months) % DateTime.monthsPerYear);

    int days = date.day + duration.days - 1;

    return DateTime(years, months, 1).add(Duration(days: days));
  }

  static DateDuration age(DateTime birthdate, {DateTime? today}) {
    return dateDifference(fromDate: birthdate, toDate: today ?? DateTime.now());
  }

  static DateDuration timeToNextBirthday(DateTime birthdate,
      {DateTime? fromDate}) {
    DateTime endDate = fromDate ?? DateTime.now();
    DateTime tempDate = DateTime(endDate.year, birthdate.month, birthdate.day);
    DateTime nextBirthdayDate = tempDate.isBefore(endDate)
        ? AgeCalculator.add(date: tempDate, duration: DateDuration(years: 1))
        : tempDate;
    return dateDifference(fromDate: endDate, toDate: nextBirthdayDate);
  }
}