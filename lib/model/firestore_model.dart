import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutsnbolts/entities/bid_entity.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';
import 'package:nutsnbolts/entities/user_entity.dart';
import 'package:nutsnbolts/model/storage_model.dart';
import 'package:nutsnbolts/services/location_service.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';

class FirestoreModel {
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //
  // user
  //
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
          rating: 5,
          numRating: 1);

      await addUser(userEntity);

      return userEntity;
    }
  }

  //
  // case
  //
  Future<CaseEntity> addCase(Map<String, dynamic> controllers, UserUsecase userUsecase, File picFile, Uint8List picBytes) async {
    LocationData location = await LocationService().getLiveLocation();

    String docId = firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc().id;

    String imagePath = "$docId${p.extension(picFile.path)}";
    debugPrint(imagePath);

    CaseEntity caseEntity = CaseEntity(
        caseId: docId,
        caseTitle: controllers[CaseEntityAttr.caseTitle.value].text,
        caseDesc: controllers[CaseEntityAttr.caseDesc.value].text,
        casePosted: Timestamp.fromDate(DateTime.now()),
        status: 0,
        type: Specialty.homeRepair.value,
        imageLink: imagePath,
        publicImageLink: '',
        clientName: userUsecase.userEntity.userName,
        clientPhoneNo: userUsecase.userEntity.phoneNo,
        caseLocation: GeoPoint(location.latitude!, location.longitude!),
        technicianId: '',
        technicianName: '',
        technicianPhoneNo: '',
        technicianLocation: const GeoPoint(0, 0),
        technicianPrice: [],
        appointment: Timestamp.fromDate(DateTime.now()),
        caseResolvedTime: Timestamp.fromDate(DateTime.now()));

    // post image at storage
    String link = await StorargeModel().postImage(imagePath, userUsecase.userEntity.uid, picFile);

    caseEntity.publicImageLink = link;

    // post at firestore
    await firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc(docId).set(caseEntity.toMap());

    caseEntity.image = picBytes;
    caseEntity.imageFile = picFile;

    return caseEntity;
  }

  Future<void> addBid(String price, UserUsecase userUsecase, CaseEntity caseEntity) async {
    BidEntity bidEntity = BidEntity(
        technicianId: userUsecase.userEntity.uid,
        technicianName: userUsecase.userEntity.userName,
        price: double.parse(price),
        rating: userUsecase.userEntity.rating);
    caseEntity.technicianPrice.add(bidEntity.toMap());

    // post at firestore
    await firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc(caseEntity.caseId).set(caseEntity.toMap());
  }

  //
  // chat
  //
  Future<void> updateChat() async {}
}
