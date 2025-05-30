class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String type;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.type,
  });



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type,
    };
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      type: json['type'],
    );
  }
}


