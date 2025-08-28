class AuthUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
    id: j['id'],
    username: j['username'] ?? '',
    email: j['email'] ?? '',
    firstName: j['firstName'] ?? '',
    lastName: j['lastName'] ?? '',
    image: j['image'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'image': image,
  };
}
