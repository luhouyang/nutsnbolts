import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:nutsnbolts/entities/user_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity = UserEntity(uid: " ", userName: " ", email: " ", phoneNo: " ", location: const GeoPoint(0, 0), isTechnician: false);

  Future<void> getUser(String uid) async {
    UserEntity newUserEntity = await FirestoreModel().getUser(uid);
    userEntity = newUserEntity;
    notifyListeners();
  }
}
