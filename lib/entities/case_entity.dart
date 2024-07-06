import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

// inside each case, after confirming technician
// there will be collection named "message"

enum CaseEntityAttr {
  caseId("caseId"),
  caseTitle("caseTitle"),
  caseDesc("caseDesc"),
  clientPrice("clientPrice");

  final String value;
  const CaseEntityAttr(this.value);
}

class CaseEntity {
  // case
  String caseId; // auto
  String caseTitle; // user
  String caseDesc; // user
  Timestamp casePosted; // auto
  bool status; // true (open), false (closed/taken)
  String imageLink;
  Uint8List? image;

  // client
  String clientName; // auto
  String clientPhoneNo; // auto
  GeoPoint caseLocation; // user

  // technician
  String technicianName; // technician, auto
  String technicianPhoneNo; // technician, auto
  GeoPoint technicianLocation; // live location of technician when heading to house?

  // during negotiation
  double clientPrice; // user
  double technicianPrice; // only lowest price gets stored, this price is final price

  // after confirm technician
  Timestamp appointment; // user, technician
  Timestamp caseResolvedTime; // user

  CaseEntity(
      {required this.caseId,
      required this.caseTitle,
      required this.caseDesc,
      required this.casePosted,
      required this.status,
      required this.clientName,
      required this.clientPhoneNo,
      required this.caseLocation,
      required this.technicianName,
      required this.technicianPhoneNo,
      required this.technicianLocation,
      required this.clientPrice,
      required this.technicianPrice,
      required this.appointment,
      required this.caseResolvedTime,
      required this.imageLink});

  factory CaseEntity.from(Map<String, dynamic> map) {
    return CaseEntity(
      caseId: map["caseId"],
      caseTitle: map["caseTitle"],
      caseDesc: map["caseDesc"],
      casePosted: map["casePosted"] as Timestamp,
      status: map["status"],
      imageLink: map["imageLink"],
      clientName: map["clientName"],
      clientPhoneNo: map["clientPhoneNo"],
      caseLocation: map["caseLocation"] as GeoPoint,
      technicianName: map["technicianName"],
      technicianPhoneNo: map["technicianPhoneNo"],
      technicianLocation: map["technicianLocation"],
      clientPrice: map["clientPrice"],
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
      'imageLink': imageLink,
      'clientName': clientName,
      'clientPhoneNo': clientPhoneNo,
      'caseLocation': caseLocation,
      'technicianName': technicianName,
      'technicianPhoneNo': technicianPhoneNo,
      'technicianLocation': technicianLocation,
      'clientPrice': clientPrice,
      'technicianPrice': technicianPrice,
      'appointment': appointment,
      'caseResolvedTime': caseResolvedTime,
    };
  }
}
