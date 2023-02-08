import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';

/// This adds a (fictitious) event to the test device's calendar
void addEventHandler() {
  if (kDebugMode) {
    print("addEventHandler");
  }
  var start = DateTime.parse("2024-04-01T13:00");
  Add2Calendar.addEvent2Cal(Event(
    // Starts at the given time, and runs for an hour and a half
      startDate: DateTime.parse("2024-04-01T13:00"),
      endDate: start.add(const Duration(hours: 1, minutes: 30)),
      title: "Staff Meeting",
      description: "Another Exciting Staff Meeting",
      location: "Main auditorium",
      // Set a 10-minute warning for the meeting
      // Reminders not working on Android yet
      iosParams: const IOSParams(
          reminder: Duration(minutes:10)
      )));
  }