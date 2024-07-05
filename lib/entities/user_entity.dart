import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String userName;
  String email;
  String phoneNo;
  GeoPoint location;

  UserEntity({required this.userName, required this.email, required this.phoneNo, required this.location});

  factory UserEntity.from(Map<String, dynamic> map) {
    return UserEntity(userName: map["userName"], email: map["email"], phoneNo: map["phoneNo"], location: map["location"] as GeoPoint);
  }

  Map toMap() {
    return {
      'userName': userName,
      'email': email,
      'phoneNo': phoneNo,
      'location': location,
    };
  }
}
