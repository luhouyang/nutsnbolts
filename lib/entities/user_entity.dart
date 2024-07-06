import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String uid;
  String userName;
  String email;
  String phoneNo;
  String photoUrl;
  GeoPoint location;
  bool isTechnician;
  List<dynamic> specialty;
  double rating;
  int numRating;
  List<dynamic> nuts;

  UserEntity(
      {required this.uid,
      required this.userName,
      required this.email,
      required this.phoneNo,
      required this.photoUrl,
      required this.location,
      required this.isTechnician,
      required this.specialty,
      required this.rating,
      required this.numRating,
      required this.nuts});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map["uid"],
      userName: map["userName"],
      email: map["email"],
      phoneNo: map["phoneNo"],
      photoUrl: map["photoUrl"],
      location: map["location"] as GeoPoint,
      isTechnician: map["isTechnician"],
      specialty: map["specialty"],
      rating: double.parse(map["rating"].toString()),
      numRating: map["numRating"],
      nuts: map["nuts"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'phoneNo': phoneNo,
      'photoUrl': photoUrl,
      'location': location,
      'isTechnician': isTechnician,
      'specialty': specialty,
      'rating': rating,
      'numRating': numRating,
      'nuts': nuts,
    };
  }
}
