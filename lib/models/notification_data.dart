import 'package:flutter/material.dart';
import 'app_enums.dart';

class NotificationData {
  const NotificationData(
    this.title,
    this.message,
    this.time,
    this.kind,
    this.color,
  );
  final String title, message, time;
  final NotificationKind kind;
  final Color color;
}
