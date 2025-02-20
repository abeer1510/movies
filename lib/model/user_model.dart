class UserModel {
  String name;
  String email;
  String password;
  String confirmPassword;
  String phone;
  int avaterId;
  List<int> history;
  List<int> favorites;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.avaterId,
    this.history = const [],
    this.favorites = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "phone": phone,
      "avaterId": avaterId,
      "history": history,
      "favorites": favorites,
    };
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      phone: json['phone'] ?? '',
      avaterId: json['avaterId'] ?? 0,
      history: List<int>.from(json['history'] ?? []),
      favorites: List<int>.from(json['favorites'] ?? []),
    );
  }
}
