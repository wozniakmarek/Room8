import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

import 'challenge.dart';

class ChallengesDataSource extends CalendarDataSource<Challenge> {
  ChallengesDataSource(List<Challenge> source) {
    appointments = source;
  }

  Appointment getEvent(int index) => appointments![index] as Appointment;

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getNotes(int index) {
    return appointments![index].description;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }

  @override
  List<DateTime> getRecurrenceExceptionDates(int index) {
    return appointments![index].exceptionDates;
  }

  @override
  Object getRecurrenceID(int index) {
    return appointments![index].recurrenceId;
  }

  @override
  Object getID(int index) {
    return appointments![index].id;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments![index].fromZone;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments![index].toZone;
  }

  @override
  bool isSpanned(int index) {
    return appointments![index].isSpanned;
  }

  @override
  bool isSpannedRegion(int index) {
    return appointments![index].isSpannedRegion;
  }

  @override
  bool isSpannedRegionStart(int index) {
    return appointments![index].isSpannedRegionStart;
  }

  @override
  bool isSpannedRegionEnd(int index) {
    return appointments![index].isSpannedRegionEnd;
  }

  @override
  bool isSpannedRegionMiddle(int index) {
    return appointments![index].isSpannedRegionMiddle;
  }

  @override
  bool isRecurrenceAppointment(int index) {
    return appointments![index].isRecurrence;
  }

  @override
  bool isRecurrenceException(int index) {
    return appointments![index].isException;
  }

  @override
  bool isRecurrenceSeries(int index) {
    return appointments![index].isRecurrenceSeries;
  }

  @override
  bool isRecurrenceRange(int index) {
    return appointments![index].isRecurrenceRange;
  }

  @override
  bool isRecurrenceEndDate(int index) {
    return appointments![index].isRecurrenceEndDate;
  }

  @override
  bool isRecurrenceCount(int index) {
    return appointments![index].isRecurrenceCount;
  }

  @override
  bool isRecurrenceNeverEnd(int index) {
    return appointments![index].isRecurrenceNeverEnd;
  }

  @override
  bool isRecurrenceMonthly(int index) {
    return appointments![index].isRecurrenceMonthly;
  }

  @override
  bool isRecurrenceYearly(int index) {
    return appointments![index].isRecurrenceYearly;
  }

  @override
  bool isRecurrenceWeekly(int index) {
    return appointments![index].isRecurrenceWeekly;
  }

  @override
  bool isRecurrenceDaily(int index) {
    return appointments![index].isRecurrenceDaily;
  }

  @override
  bool isRecurrenceMonthlyDOW(int index) {
    return appointments![index].isRecurrenceMonthlyDOW;
  }

  @override
  bool isRecurrenceYearlyDOW(int index) {
    return appointments![index].isRecurrenceYearlyDOW;
  }

  @override
  bool isRecurrenceMonthlyDOM(int index) {
    return appointments![index].isRecurrenceMonthlyDOM;
  }

  @override
  bool isRecurrenceYearlyDOM(int index) {
    return appointments![index].isRecurrenceYearlyDOM;
  }

  @override
  bool isRecurrenceFirstDay(int index) {
    return appointments![index].isRecurrenceFirstDay;
  }

  @override
  bool isRecurrenceSecondDay(int index) {
    return appointments![index].isRecurrenceSecondDay;
  }

  @override
  bool isRecurrenceThirdDay(int index) {
    return appointments![index].isRecurrenceThirdDay;
  }

  @override
  bool isRecurrenceFourthDay(int index) {
    return appointments![index].isRecurrenceFourthDay;
  }

  @override
  bool isRecurrenceLastDay(int index) {
    return appointments![index].isRecurrenceLastDay;
  }

  @override
  bool isRecurrenceSecondLastDay(int index) {
    return appointments![index].isRecurrenceSecondLastDay;
  }

  @override
  bool isRecurrenceThirdLastDay(int index) {
    return appointments![index].isRecurrenceThirdLastDay;
  }

  @override
  bool isRecurrenceFourthLastDay(int index) {
    return appointments![index].isRecurrenceFourthLastDay;
  }

  @override
  bool isRecurrenceFirstWeek(int index) {
    return appointments![index].isRecurrenceFirstWeek;
  }

  @override
  bool isRecurrenceSecondWeek(int index) {
    return appointments![index].isRecurrenceSecondWeek;
  }

  @override
  bool isRecurrenceThirdWeek(int index) {
    return appointments![index].isRecurrenceThirdWeek;
  }

  @override
  bool isRecurrenceFourthWeek(int index) {
    return appointments![index].isRecurrenceFourthWeek;
  }

  @override
  bool isRecurrenceLastWeek(int index) {
    return appointments![index].isRecurrenceLastWeek;
  }

  @override
  bool isRecurrenceSecondLastWeek(int index) {
    return appointments![index].isRecurrenceSecondLastWeek;
  }

  @override
  bool isRecurrenceThirdLastWeek(int index) {
    return appointments![index].isRecurrenceThirdLastWeek;
  }

  @override
  bool isRecurrenceFourthLastWeek(int index) {
    return appointments![index].isRecurrenceFourthLastWeek;
  }

  @override
  bool isRecurrenceFirstMonth(int index) {
    return appointments![index].isRecurrenceFirstMonth;
  }

  @override
  bool isRecurrenceSecondMonth(int index) {
    return appointments![index].isRecurrenceSecondMonth;
  }

  @override
  bool isRecurrenceThirdMonth(int index) {
    return appointments![index].isRecurrenceThirdMonth;
  }

  @override
  bool isRecurrenceFourthMonth(int index) {
    return appointments![index].isRecurrenceFourthMonth;
  }

  @override
  bool isRecurrenceFifthMonth(int index) {
    return appointments![index].isRecurrenceFifthMonth;
  }

  @override
  bool isRecurrenceSixthMonth(int index) {
    return appointments![index].isRecurrenceSixthMonth;
  }

  @override
  bool isRecurrenceSeventhMonth(int index) {
    return appointments![index].isRecurrenceSeventhMonth;
  }

  @override
  bool isRecurrenceEighthMonth(int index) {
    return appointments![index].isRecurrenceEighthMonth;
  }

  @override
  bool isRecurrenceNinthMonth(int index) {
    return appointments![index].isRecurrenceNinthMonth;
  }

  @override
  bool isRecurrenceTenthMonth(int index) {
    return appointments![index].isRecurrenceTenthMonth;
  }

  @override
  bool isRecurrenceEleventhMonth(int index) {
    return appointments![index].isRecurrenceEleventhMonth;
  }

  @override
  bool isRecurrenceTwelfthMonth(int index) {
    return appointments![index].isRecurrenceTwelfthMonth;
  }

  @override
  bool isRecurrenceFirstYear(int index) {
    return appointments![index].isRecurrenceFirstYear;
  }

  @override
  bool isRecurrenceSecondYear(int index) {
    return appointments![index].isRecurrenceSecondYear;
  }

  @override
  bool isRecurrenceThirdYear(int index) {
    return appointments![index].isRecurrenceThirdYear;
  }

  @override
  bool isRecurrenceFourthYear(int index) {
    return appointments![index].isRecurrenceFourthYear;
  }

  @override
  bool isRecurrenceFifthYear(int index) {
    return appointments![index].isRecurrenceFifthYear;
  }

  @override
  bool isRecurrenceSixthYear(int index) {
    return appointments![index].isRecurrenceSixthYear;
  }

  @override
  bool isRecurrenceSeventhYear(int index) {
    return appointments![index].isRecurrenceSeventhYear;
  }

  @override
  bool isRecurrenceEighthYear(int index) {
    return appointments![index].isRecurrenceEighthYear;
  }

  @override
  bool isRecurrenceNinthYear(int index) {
    return appointments![index].isRecurrenceNinthYear;
  }

  @override
  bool isRecurrenceTenthYear(int index) {
    return appointments![index].isRecurrenceTenthYear;
  }

  @override
  bool isRecurrenceEleventhYear(int index) {
    return appointments![index].isRecurrenceEleventhYear;
  }

  @override
  bool isRecurrenceTwelfthYear(int index) {
    return appointments![index].isRecurrenceTwelfthYear;
  }

  @override
  bool isRecurrenceThirteenthYear(int index) {
    return appointments![index].isRecurrenceThirteenthYear;
  }

  @override
  bool isRecurrenceFourteenthYear(int index) {
    return appointments![index].isRecurrenceFourteenthYear;
  }

  @override
  bool isRecurrenceFifteenthYear(int index) {
    return appointments![index].isRecurrenceFifteenthYear;
  }

  @override
  bool isRecurrenceSixteenthYear(int index) {
    return appointments![index].isRecurrenceSixteenthYear;
  }

  @override
  bool isRecurrenceSeventeenthYear(int index) {
    return appointments![index].isRecurrenceSeventeenthYear;
  }

  @override
  bool isRecurrenceEighteenthYear(int index) {
    return appointments![index].isRecurrenceEighteenthYear;
  }

  @override
  bool isRecurrenceNineteenthYear(int index) {
    return appointments![index].isRecurrenceNineteenthYear;
  }

  @override
  int getPoints(int index) {
    return appointments![index].points;
  }

  @override
  String getUserId(int index) {
    return appointments![index].userId;
  }

  @override
  String getUserName(int index) {
    return appointments![index].userName;
  }

  @override
  int getCategory(int index) {
    return appointments![index].category;
  }

  @override
  Color getColor(int index) {
    String color = appointments![index].color.toString();
    int colorInt = int.parse(color, radix: 16);
    Color colorValue = Color(colorInt);
    return colorValue;
  }

  @override
  Challenge? convertAppointmentToObject(
      Challenge? customData, Appointment appointment) {
    return Challenge(
      title: appointment.subject,
      description: customData!.description,
      from: appointment.startTime,
      to: appointment.endTime,
      isAllDay: appointment.isAllDay,
      id: customData.id,
      recurrenceId: appointment.recurrenceId,
      recurrenceRule: appointment.recurrenceRule,
      exceptionDates: appointment.recurrenceExceptionDates,
      isRecurrence: customData.isRecurrence,
      completed: customData.completed,
      category: customData.category,
      color: customData.color,
      points: customData.points,
      userId: customData.userId,
      userName: customData.userName,
    );
  }
}
