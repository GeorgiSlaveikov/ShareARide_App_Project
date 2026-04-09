class User {
  int? id; 
  String username;
  String firstName;
  String lastName;
  String email;

  
  // Standard Constructor
  User({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // 1. Factory constructor to create a User from a JSON Map
  // This is what you use when receiving data from the .NET API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? ''
    );
  }

  // 2. Method to convert User object to a JSON Map
  // This is what you use when sending data TO the .NET API (like Register)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email
    };
  }

  @override
  String toString() {
    return 'Username: $username\nFirst Name: $firstName\nLast Name: $lastName\nEmail: $email';
  }
}