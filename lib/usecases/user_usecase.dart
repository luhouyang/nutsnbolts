import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:nutsnbolts/entities/user_entity.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity =
      UserEntity(uid: "uid", userName: "userName", email: "email", phoneNo: "phoneNo", location: GeoPoint(81.44, 87.65), isTechnician: false);
}
