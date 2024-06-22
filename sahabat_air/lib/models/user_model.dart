class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? address;
  final String? phone;

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.address,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      phone: map['phone'],
    );
  }
}
