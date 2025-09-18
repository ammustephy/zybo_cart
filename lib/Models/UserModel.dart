
class User {
  final String userId;
  final String firstName;
  final String phoneNumber;

  User({
    required this.userId,
    required this.firstName,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}