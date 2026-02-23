class UserProfile {
  final String username;
  final String password;

  UserProfile(this.username, this.password);

  Map<String, dynamic> toJson() =>
      {"username": username, "password": password};

  factory UserProfile.fromJson(Map<String, dynamic> j) =>
      UserProfile(j["username"], j["password"]);
}