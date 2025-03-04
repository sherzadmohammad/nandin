import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? timeAgo(BuildContext context, DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  final int seconds = difference.inSeconds;
  final int minutes = difference.inMinutes;
  final int hours = difference.inHours;
  final int days = difference.inDays;
  final int weeks = days ~/ 7;
  final int months = days ~/ 30;
  final int years = days ~/ 365;

  if (seconds < 60) {
    return AppLocalizations.of(context)?.time_ago_just_now;
  } else if (minutes < 2) {
    return AppLocalizations.of(context)?.time_ago_minute;
  } else if (minutes < 60) {
    return AppLocalizations.of(context)?.time_ago_minutes(minutes.toString());
  } else if (hours < 2) {
    return AppLocalizations.of(context)?.time_ago_hour;
  } else if (hours < 24) {
    return AppLocalizations.of(context)?.time_ago_hours(hours.toString());
  } else if (days < 2) {
    return AppLocalizations.of(context)?.time_ago_day;
  } else if (days < 7) {
    return AppLocalizations.of(context)?.time_ago_days(days.toString());
  } else if (weeks < 2) {
    return AppLocalizations.of(context)?.time_ago_week;
  } else if (days < 30) {
    return AppLocalizations.of(context)?.time_ago_weeks(weeks.toString());
  } else if (months < 2) {
    return AppLocalizations.of(context)?.time_ago_month;
  } else if (days < 365) {
    return AppLocalizations.of(context)?.time_ago_months(months.toString());
  } else if (years < 2) {
    return AppLocalizations.of(context)?.time_ago_year;
  } else {
    return AppLocalizations.of(context)?.time_ago_years(years.toString());
  }
}