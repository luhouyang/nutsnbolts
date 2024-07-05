import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String uid;
  String userName;
  String email;
  String phoneNo;
  GeoPoint location;
  bool isTechnician;

  UserEntity(
      {required this.uid, required this.userName, required this.email, required this.phoneNo, required this.location, required this.isTechnician});

  factory UserEntity.from(Map<String, dynamic> map) {
    return UserEntity(
      uid: map["uid"],
      userName: map["userName"],
      email: map["email"],
      phoneNo: map["phoneNo"],
      location: map["location"] as GeoPoint,
      isTechnician: map["isTechnician"],
    );
  }

  Map toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'phoneNo': phoneNo,
      'location': location,
      'isTechnician': isTechnician,
    };
  }
}
