class User {
  final String username;
  final String group;

  User({required this.username, required this.group});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      group: json['group'] ?? '',
    );
  }
}