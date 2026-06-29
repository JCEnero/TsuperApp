import 'package:flutter/material.dart';

class JeepneyData {
  const JeepneyData(
    this.unit,
    this.route,
    this.occupancy,
    this.status,
    this.eta,
    this.color,
  );
  final String unit, route, occupancy, status, eta;
  final Color color;
}
