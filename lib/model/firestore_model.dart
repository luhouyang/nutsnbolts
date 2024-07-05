import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';

class FirestoreModel {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addCase(CaseEntity caseEntity, UserUsecase userUsecase) async {
    String docId = firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc().id;
    await firebaseFirestore.collection('users').doc(userUsecase.userEntity.uid).collection('cases').doc(docId).set(caseEntity.toMap());
  }
}
