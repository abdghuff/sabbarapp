class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? userType;
  String? phone;
  //String? province;
  UserModel({this.uid, this.email, this.firstName, this.userType, this.phone});

  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      userType: map['userType'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'userType': userType,
      'phone': phone,
    };
  }
}