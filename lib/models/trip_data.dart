import 'package:flutter/material.dart';

class TripData {
  const TripData(
    this.title,
    this.subtitle,
    this.amount,
    this.status,
    this.color,
  );
  final String title, subtitle, amount, status;
  final Color color;
}
