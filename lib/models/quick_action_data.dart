import 'package:flutter/material.dart';

class QuickActionData {
  const QuickActionData(this.label, this.icon, this.color, this.subtitle);
  final String label, subtitle;
  final IconData icon;
  final Color color;
}
