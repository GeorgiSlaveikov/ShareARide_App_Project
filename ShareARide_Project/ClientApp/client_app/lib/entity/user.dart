class User {
  int? id; 
  String username;
  String firstName;
  String lastName;
  int age;
  String email;
  String phoneNumber;
  int tripsCount;
  double rating;
  String? profilePicturePath;

  User({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.phoneNumber,
    required this.tripsCount,
    required this.rating,
    this.profilePicturePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 18,
      email: json['email'] ?? '',
      tripsCount: json['tripsCount'] ?? 0,
      rating: json['rating'] ?? 0.0,
      phoneNumber: json['phoneNumber'] ?? ''
    );
  }

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