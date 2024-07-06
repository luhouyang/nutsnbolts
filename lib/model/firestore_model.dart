import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';
import 'package:nutsnbolts/entities/user_entity.dart';
import 'package:nutsnbolts/services/location_service.dart';
import 'package:nutsnbolts/testdata/test_data.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';

class FirestoreModel {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserEntity userEntity) async {
    await firebaseFirestore.collection('users').doc(userEntity.uid).set(userEntity.toMap());
  }

  Future<UserEntity> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await firebaseFirestore.collection('users').doc(uid).get();
      return UserEntity.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint("Error: $e");

      LocationData location = await LocationService().getLiveLocation();

      final user = FirebaseAuth.instance.currentUser;

      UserEntity userEntity = UserEntity(
          uid: uid,
          userName: user!.displayName!,
          email: user.email!,
          phoneNo: user.phoneNumber!,
          location: GeoPoint(location.latitude!, location.longitude!),
          isTechnician: false,
          specialty: Specialty.homeRepair.value,
          rating: 0);

      await addUser(userEntity);
      
      return userEntity;
    }
  }

  Future<void> addCase(Map<String, dynamic> controllers, UserUsecase userUsecase, Uint8List picBytes, String picPath) async {
    CaseEntity caseEntity = TestData.caseEntity;

    caseEntity.caseTitle = controllers[CaseEntityAttr.caseTitle.value].text;
    caseEntity.caseDesc = controllers[CaseEntityAttr.caseDesc.value].text;
    caseEntity.clientPrice = double.parse(controllers[CaseEntityAttr.clientPrice.value].text);

    caseEntity.clientName = userUsecase.userEntity.userName;
    caseEntity.clientPhoneNo = userUsecase.userEntity.phoneNo;

    String docId = firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc().id;
    await firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc(docId).set(caseEntity.toMap());
  }
}
