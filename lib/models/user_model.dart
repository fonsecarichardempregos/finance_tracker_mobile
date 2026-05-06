class User {
  User();

  num? id;
  String? fullName;
  String? email;
  String? phone;
  String? birthDate;
  String? createdAt;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    createdAt = json['createdAt'];
  }

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, email: $email, phone: $phone, birthDate: $birthDate, createdAt: $createdAt}';
  }
}
