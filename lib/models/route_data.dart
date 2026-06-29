import 'package:flutter/material.dart';

class RouteData {
  const RouteData(
    this.title,
    this.origin,
    this.destination,
    this.fare,
    this.duration,
    this.transfers,
    this.traffic,
    this.color,
  );
  final String title, origin, destination, fare, duration, traffic;
  final int transfers;
  final Color color;
}
