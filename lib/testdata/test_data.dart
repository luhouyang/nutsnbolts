// Third-party package imports
import 'package:cloud_firestore/cloud_firestore.dart';

// Local project imports - Entities
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';

class TestData {
  static CaseEntity caseEntity = CaseEntity(
      caseId: 'caseId',
      caseTitle: 'caseTitle',
      caseDesc: 'caseDesc',
      casePosted: Timestamp.fromDate(DateTime.now()),
      status: 0,
      type: Specialty.homeRepair.value,
      finalPrice: 0.0,
      imageLink: '',
      publicImageLink: '',
      clientId: 'clientId',
      clientName: 'clientName',
      clientPhoneNo: 'clientPhoneNo',
      caseLocation: const GeoPoint(81.44, 87.65),
      photoUrl: " ",
      technicianId: '',
      technicianName: 'technicianName',
      technicianPhoneNo: 'technicianPhoneNo',
      technicianLocation: const GeoPoint(82.44, 87.05),
      technicianPrice: [],
      appointment: Timestamp.fromDate(DateTime.now()),
      caseResolvedTime: Timestamp.fromDate(DateTime.now()));
}
