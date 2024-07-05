import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutsnbolts/entities/case_entity.dart';

class TestData {
  static CaseEntity caseEntity = CaseEntity(
      caseId: 'caseId',
      caseTitle: 'caseTitle',
      caseDesc: 'caseDesc',
      casePosted: Timestamp.fromDate(DateTime.now()),
      status: false,
      clientName: 'clientName',
      clientPhoneNo: 'clientPhoneNo',
      caseLocation: GeoPoint(81.44, 87.65),
      technicianName: 'technicianName',
      technicianPhoneNo: 'technicianPhoneNo',
      technicianLocation: GeoPoint(82.44, 87.05),
      clientPrice: 20,
      technicianPrice: 22.5,
      appointment: Timestamp.fromDate(DateTime.now()),
      caseResolvedTime: Timestamp.fromDate(DateTime.now()));
}
