import 'package:flutter/material.dart';

/// A single location result from a place search.
///
/// Fields map 1-to-1 to the Google Places Autocomplete API response so
/// swapping [MockPlacesRepository] for a real API implementation requires
/// no changes to any widget or screen.
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
    required this.icon,
    this.iconColor,
    this.distanceLabel,
  });

  /// Opaque identifier — will become a Places API place_id in production.
  final String placeId;

  /// Bold first line (e.g. "SM City Fairview").
  final String primaryText;

  /// Muted second line (e.g. "Quezon City, Metro Manila").
  final String secondaryText;

  /// Icon representing the place category.
  final IconData icon;

  /// Optional tint for the icon container.
  final Color? iconColor;

  /// Optional human-readable distance string (e.g. "1.2 km").
  final String? distanceLabel;
}

/// A saved place (home, work, or user-defined favorite).
class SavedPlace {
  const SavedPlace({
    required this.placeId,
    required this.label,
    required this.address,
    required this.icon,
    required this.iconColor,
  });

  final String placeId;
  final String label;
  final String address;
  final IconData icon;
  final Color iconColor;
}
