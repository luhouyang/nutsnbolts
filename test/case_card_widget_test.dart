import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/widgets/case_card.dart'; // Import CaseEntity class

void main() {
  group('CaseCard Widget', () {
    testWidgets('Widget displays correct case details',
        (WidgetTester tester) async {
      // Create a CaseEntity instance with sample data
      CaseEntity caseEntity = CaseEntity(
        caseId: '123',
        caseTitle: 'Sample Case',
        caseDesc: 'Sample description for testing',
        casePosted: Timestamp.now(),
        status: 0,
        type: 'Repair',
        finalPrice: 100.0,
        clientId: '9GLrGlQOQqemy0790Ttqt3UP43M2',
        clientName: 'John Doe',
        clientPhoneNo: '123-456-7890',
        caseLocation: GeoPoint(1.234, 5.678),
        technicianId: 'tech456',
        technicianName: 'Jane Smith',
        technicianPhoneNo: '987-654-3210',
        technicianLocation: GeoPoint(5.678, 1.234),
        technicianPrice: [80.0, 100.0, 120.0],
        appointment: Timestamp.now(),
        caseResolvedTime: Timestamp.now(),
        imageLink: 'https://example.com/image.jpg',
        publicImageLink: 'https://example.com/public.jpg',
      );

      // Build the CaseCard widget with the sample CaseEntity
      await tester.pumpWidget(
        MaterialApp(
          home: CaseCard(caseEntity: caseEntity),
        ),
      );

      // Verify that the widget displays the correct details
      expect(find.text('Sample Case'), findsOneWidget);
      expect(find.text('Sample description for testing'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Repair'), findsOneWidget);
      // Add more assertions as per CaseCard UI
    });
  });
}
