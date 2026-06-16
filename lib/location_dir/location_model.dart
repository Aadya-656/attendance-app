// ============================================================
// FILE 1 of 4: lib/models/location_model.dart
// ============================================================

enum GeofenceRadius {
  fifty(50, '50 m'),
  hundred(100, '100 m');

  final int meters;
  final String label;
  const GeofenceRadius(this.meters, this.label);
}

class CoordinatePreset {
  final String label;
  final double lat;
  final double lng;
  const CoordinatePreset({required this.label, required this.lat, required this.lng});
}

class OfficeSite {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final GeofenceRadius radius;
  final bool isActive;
  final DateTime updatedAt;

  OfficeSite({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.radius,
    this.isActive = true,
    required this.updatedAt,
  });

  OfficeSite copyWith({
    String? name, double? lat, double? lng,
    GeofenceRadius? radius, bool? isActive, DateTime? updatedAt,
  }) {
    return OfficeSite(
      id: id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radius: radius ?? this.radius,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LocationConstants {
  static const Map<String, List<CoordinatePreset>> officePresets = {
    'Chanakyapuri': [
      CoordinatePreset(label: 'CRIS HQ — Gate 1',   lat: 28.5921, lng: 77.1897),
      CoordinatePreset(label: 'CRIS HQ — Gate 2',   lat: 28.5918, lng: 77.1901),
      CoordinatePreset(label: 'CRIS HQ — Parking',  lat: 28.5915, lng: 77.1905),
    ],
    'ITO': [
      CoordinatePreset(label: 'ITO — Main Entrance', lat: 28.6289, lng: 77.2414),
      CoordinatePreset(label: 'ITO — Block B',       lat: 28.6285, lng: 77.2418),
      CoordinatePreset(label: 'ITO — Metro Exit',    lat: 28.6281, lng: 77.2422),
    ],
    'DMRC': [
      CoordinatePreset(label: 'DMRC — Corporate Office',    lat: 28.6328, lng: 77.2197),
      CoordinatePreset(label: 'DMRC — Barakhamba Annex',    lat: 28.6324, lng: 77.2201),
      CoordinatePreset(label: 'DMRC — Shivaji Stadium',     lat: 28.6320, lng: 77.2205),
    ],
  };

  static const List<String> officeNames = ['Chanakyapuri', 'ITO', 'DMRC'];
}