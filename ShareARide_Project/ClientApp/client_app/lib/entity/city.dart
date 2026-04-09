class City {
  int? id; 
  String name;

  // Standard Constructor
  City({
    this.id,
    required this.name
  });

  // 1. Factory constructor to create a User from a JSON Map
  // This is what you use when receiving data from the .NET API
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? ''
    );
  }

  // 2. Method to convert User object to a JSON Map
  // This is what you use when sending data TO the .NET API (like Register)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  
  @override
  String toString() {
    return 'Name: $name\n';
  }
}