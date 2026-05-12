import 'package:flutter/material.dart';

class AccessiblePlace {
  final String id;
  final String externalId;
  final String source;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String distance;
  final double rating;
  final List<String> tags;
  final bool wheelchairAccessible;
  final bool hasRamp;
  final bool hasElevator;
  final bool hasAccessibleToilet;
  final bool hasQuietArea;
  final bool corridorWide;
  final int userCommentCount;
  final Color color;

  const AccessiblePlace({
    required this.id,
    required this.externalId,
    required this.source,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.rating,
    required this.tags,
    required this.wheelchairAccessible,
    required this.hasRamp,
    required this.hasElevator,
    required this.hasAccessibleToilet,
    required this.hasQuietArea,
    required this.corridorWide,
    required this.userCommentCount,
    required this.color,
  });

  AccessiblePlace copyWith({
    String? id,
    String? externalId,
    String? source,
    String? name,
    String? category,
    double? latitude,
    double? longitude,
    String? distance,
    double? rating,
    List<String>? tags,
    bool? wheelchairAccessible,
    bool? hasRamp,
    bool? hasElevator,
    bool? hasAccessibleToilet,
    bool? hasQuietArea,
    bool? corridorWide,
    int? userCommentCount,
    Color? color,
  }) {
    return AccessiblePlace(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      source: source ?? this.source,
      name: name ?? this.name,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      hasRamp: hasRamp ?? this.hasRamp,
      hasElevator: hasElevator ?? this.hasElevator,
      hasAccessibleToilet: hasAccessibleToilet ?? this.hasAccessibleToilet,
      hasQuietArea: hasQuietArea ?? this.hasQuietArea,
      corridorWide: corridorWide ?? this.corridorWide,
      userCommentCount: userCommentCount ?? this.userCommentCount,
      color: color ?? this.color,
    );
  }
}

