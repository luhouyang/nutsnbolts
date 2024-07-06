import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

// inside each case, after confirming technician
// there will be collection named "message"

enum CaseEntityAttr {
  caseId("caseId"),
  caseTitle("caseTitle"),
  caseDesc("caseDesc"),
  type("type");

  final String value;
  const CaseEntityAttr(this.value);
}

class CaseEntity {
  // case
  String caseId; // auto
  String caseTitle; // user
  String caseDesc; // user
  Timestamp casePosted; // auto
  int status; // 0 (open), 1 (taken), 2 (complete)
  String type;
  double finalPrice;
  String imageLink;
  String publicImageLink;
  Uint8List? image;
  File? imageFile;

  // client
  String clientId;
  String clientName; // auto
  String clientPhoneNo; // auto
  GeoPoint caseLocation; // user

  // technician
  String technicianId;
  String technicianName; // technician, auto
  String technicianPhoneNo; // technician, auto
  GeoPoint technicianLocation; // live location of technician when heading to house?

  // during negotiation
  // double technicianPrice; // only lowest price gets stored, this price is final price
  List<dynamic> technicianPrice;

  // after confirm technician
  Timestamp appointment; // user, technician
  Timestamp caseResolvedTime; // user

  CaseEntity(
      {required this.caseId,
      required this.caseTitle,
      required this.caseDesc,
      required this.casePosted,
      required this.status,
      required this.type,
      required this.finalPrice,
      required this.clientId,
      required this.clientName,
      required this.clientPhoneNo,
      required this.caseLocation,
      required this.technicianId,
      required this.technicianName,
      required this.technicianPhoneNo,
      required this.technicianLocation,
      required this.technicianPrice,
      required this.appointment,
      required this.caseResolvedTime,
      required this.imageLink,
      required this.publicImageLink});

  factory CaseEntity.from(Map<String, dynamic> map) {
    return CaseEntity(
      caseId: map["caseId"],
      caseTitle: map["caseTitle"],
      caseDesc: map["caseDesc"],
      casePosted: map["casePosted"] as Timestamp,
      status: map["status"],
      type: map["type"],
      finalPrice: double.parse(map["finalPrice"].toString()),
      imageLink: map["imageLink"],
      publicImageLink: map["publicImageLink"],
      clientId: map["clientId"],
      clientName: map["clientName"],
      clientPhoneNo: map["clientPhoneNo"],
      caseLocation: map["caseLocation"] as GeoPoint,
      technicianId: map["technicianId"],
      technicianName: map["technicianName"],
      technicianPhoneNo: map["technicianPhoneNo"],
      technicianLocation: map["technicianLocation"],
      technicianPrice: map["technicianPrice"],
      appointment: map["appointment"] as Timestamp,
      caseResolvedTime: map["caseResolvedTime"] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'caseTitle': caseTitle,
      'caseDesc': caseDesc,
      'casePosted': casePosted,
      'status': status,
      'type': type,
      'finalPrice': finalPrice,
      'imageLink': imageLink,
      'publicImageLink': publicImageLink,
      'clientId': clientId,
      'clientName': clientName,
      'clientPhoneNo': clientPhoneNo,
      'caseLocation': caseLocation,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'technicianPhoneNo': technicianPhoneNo,
      'technicianLocation': technicianLocation,
      'technicianPrice': technicianPrice,
      'appointment': appointment,
      'caseResolvedTime': caseResolvedTime,
    };
  }
}
