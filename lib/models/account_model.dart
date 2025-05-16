class AccountModel {
  final String name;
  final String email;
  final String password;

  AccountModel({
    required this.name,
    required this.email,
    required this.password,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
