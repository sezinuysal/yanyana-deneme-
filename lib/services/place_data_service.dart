import 'package:flutter/material.dart';

import '../models/accessible_place.dart';
import '../theme.dart';
import 'database_bridge.dart';

/// Fetches real places from OpenStreetMap / Overpass (future),
/// maps OSM elements into [AccessiblePlace], and merges with YanYana local reviews.
class PlaceDataService {
  final DatabaseBridge databaseBridge;

  const PlaceDataService({required this.databaseBridge});

  /// Future-ready method: fetch nearby places using Overpass API.
  ///
  /// TODO: Implement Overpass API call (no http dependency in this prototype).
  /// TODO: Parse elements and map via [mapOsmElementToAccessiblePlace].
  ///
  /// Overpass query template (future):
  /// [out:json][timeout:25];
  /// (
  ///   node["amenity"~"cafe|restaurant|hospital|pharmacy|toilets"](around:RADIUS,LAT,LON);
  ///   way["amenity"~"cafe|restaurant|hospital|pharmacy|toilets"](around:RADIUS,LAT,LON);
  ///   relation["amenity"~"cafe|restaurant|hospital|pharmacy|toilets"](around:RADIUS,LAT,LON);
  ///   node["leisure"="park"](around:RADIUS,LAT,LON);
  ///   way["leisure"="park"](around:RADIUS,LAT,LON);
  /// );
  /// out center tags;
  Future<List<AccessiblePlace>> fetchNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusMeters = 1500,
  }) async {
    // Prototype fallback: use mock list until Overpass integration is implemented.
    final base = await getMockNearbyPlaces();
    return _mergeWithLocalReviews(base);
  }

  /// For now uses existing mock places from local data.
  Future<List<AccessiblePlace>> getMockNearbyPlaces() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final base = databaseBridge.getPlaces();
    return _mergeWithLocalReviews(base);
  }

  /// Maps an Overpass element to [AccessiblePlace].
  /// Expects keys like: id, type, lat/lon (node) or center{lat,lon} (way/relation), tags{}.
  AccessiblePlace mapOsmElementToAccessiblePlace(Map<String, dynamic> element) {
    final type = (element['type'] ?? 'node').toString();
    final osmId = element['id']?.toString() ?? '0';
    final tags = (element['tags'] as Map?)?.cast<String, dynamic>() ?? const {};

    final name = (tags['name']?.toString().trim().isNotEmpty ?? false)
        ? tags['name'].toString()
        : 'OSM Mekan';

    final amenity = tags['amenity']?.toString() ?? '';
    final leisure = tags['leisure']?.toString() ?? '';

    String category = 'Diğer';
    if (amenity == 'cafe') category = 'Kafe';
    if (amenity == 'restaurant') category = 'Restoran';
    if (amenity == 'hospital') category = 'Hastane';
    if (leisure == 'park') category = 'Park';

    final lat = (element['lat'] as num?)?.toDouble() ??
        (element['center']?['lat'] as num?)?.toDouble() ??
        0.0;
    final lon = (element['lon'] as num?)?.toDouble() ??
        (element['center']?['lon'] as num?)?.toDouble() ??
        0.0;

    return AccessiblePlace(
      id: 'osm:$type/$osmId',
      externalId: osmId,
      source: 'OSM',
      name: name,
      category: category,
      latitude: lat,
      longitude: lon,
      distance: '-',
      rating: 0,
      tags: const [],
      wheelchairAccessible: false,
      hasRamp: false,
      hasElevator: false,
      hasAccessibleToilet: false,
      hasQuietArea: false,
      corridorWide: false,
      userCommentCount: 0,
      color: YanYanaColors.primary,
    );
  }

  List<AccessiblePlace> _mergeWithLocalReviews(List<AccessiblePlace> base) {
    return base.map((p) {
      final reviews = databaseBridge.getReviewsForPlace(p.id);
      if (reviews.isEmpty) {
        return p.copyWith(userCommentCount: p.userCommentCount);
      }

      final avg = reviews.fold<double>(0, (sum, r) => sum + r.rating) /
          reviews.length;

      bool any(bool Function(dynamic r) fn) => reviews.any(fn);

      final mergedTags = <String>{
        ...p.tags,
        if (any((r) => r.hasRamp)) 'Rampa',
        if (any((r) => r.hasElevator)) 'Asansör',
        if (any((r) => r.hasAccessibleToilet)) 'Engelli Tuvaleti',
        if (any((r) => r.hasQuietArea)) 'Sessiz Alan',
        if (any((r) => r.corridorWide)) 'Geniş Koridor',
      }.toList();

      Color color = p.color;
      if (avg >= 4.5) color = YanYanaColors.success;
      if (avg > 0 && avg < 3.5) color = YanYanaColors.warning;

      return p.copyWith(
        rating: p.rating > 0 ? p.rating : double.parse(avg.toStringAsFixed(1)),
        userCommentCount: reviews.length,
        tags: mergedTags,
        wheelchairAccessible: any((r) => r.wheelchairAccessible) ||
            p.wheelchairAccessible,
        hasRamp: any((r) => r.hasRamp) || p.hasRamp,
        hasElevator: any((r) => r.hasElevator) || p.hasElevator,
        hasAccessibleToilet:
            any((r) => r.hasAccessibleToilet) || p.hasAccessibleToilet,
        hasQuietArea: any((r) => r.hasQuietArea) || p.hasQuietArea,
        corridorWide: any((r) => r.corridorWide) || p.corridorWide,
        color: color,
      );
    }).toList();
  }
}

