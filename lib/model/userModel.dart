class UserModel {
  String? uid;
  String? name;
  String? email;
  String? isOnline;
  String? token;
  String? lastSeen;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.token,
    this.isOnline,
    this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      token: map['token'],
      isOnline: map['is_online'],
      lastSeen: map['last_seen'],
    );
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, name: $name, email: $email}';
  }
}
