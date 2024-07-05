import 'package:cloud_firestore/cloud_firestore.dart';

// inside each case, after confirming technician
// there will be collection named "message"

class CaseEntity {
  // case
  String caseId;
  String caseTitle;
  String caseDesc;
  Timestamp casePosted;
  bool status; // true (open), false (closed/taken)

  // client
  String clientName;
  String clientPhoneNo;
  GeoPoint caseLocation;

  // technician
  String technicianName;
  String technicianPhoneNo;
  GeoPoint technicianLocation; // live location of technician when heading to house?

  // during negotiation
  double clientPrice;
  double technicianPrice; // only lowest price gets stored, this price is final price

  // after confirm technician
  Timestamp appointment;
  Timestamp caseResolvedTime;

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
      required this.caseResolvedTime});

  factory CaseEntity.from(Map<String, dynamic> map) {
    return CaseEntity(
      caseId: map["caseId"],
      caseTitle: map["caseTitle"],
      caseDesc: map["caseDesc"],
      casePosted: map["casePosted"] as Timestamp,
      status: map["status"],
      clientName: map["clientName"],
      clientPhoneNo: map["clientPhoneNo"],
      caseLocation: map["caseLocation"] as GeoPoint,
      technicianName: map["technicianName"],
      technicianPhoneNo: map["technicianPhoneNo"],
      technicianLocation: map["technicianLocation"],
      clientPrice: map["clientPrice"],
      technicianPrice: map["technicianPrice"],
      appointment: map["appointment"] as Timestamp,
      caseResolvedTime: map["caseResolved"] as Timestamp,
    );
  }

  Map toMap() {
    return {
      'caseId': caseId,
      'caseTitle': caseTitle,
      'caseDesc': caseDesc,
      'casePosted': casePosted,
      'status': status,
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
