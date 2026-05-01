class City {
  int? id;
  String name;
  double latitude;
  double longitude;

  City({
    this.id,
    required this.name,
    this.latitude = 0,
    this.longitude = 0,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  bool get hasCoordinates {
    return latitude != 0 && longitude != 0;
  }

  @override
  String toString() {
    return 'Name: $name\nLatitude: $latitude\nLongitude: $longitude\n';
  }
}
