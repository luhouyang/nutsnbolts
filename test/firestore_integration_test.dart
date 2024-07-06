import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nutsnbolts/pages/home_page.dart';
import 'package:nutsnbolts/widgets/case_card.dart'; // Import HomePage where Firestore data is used

void main() {
  group('Firestore Integration Tests', () {
    late FirebaseFirestore firestore;

    setUpAll(() async {
      // Initialize Firebase App
      await Firebase.initializeApp();

      // Get Firestore instance
      firestore = FirebaseFirestore.instance;
    });

    testWidgets('Firestore data retrieval test', (WidgetTester tester) async {
      String testUserId = '9GLrGlQOQqemy0790Ttqt3UP43M2';

      // Build the HomePage widget with a mock Provider and Firestore data
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      // Simulate waiting for Firestore data
      await tester.pump();

      // Verify that data from Firestore is correctly displayed in the UI
      expect(find.text('Your Cases'),
          findsOneWidget); // Example assertion, adjust as per UI
      expect(find.byType(CaseCard),
          findsWidgets); // Verify that CaseCards are rendered

      // Verify that Firestore data matches expected values
      QuerySnapshot snapshot = await firestore
          .collection('cases')
          .where('clientId', isEqualTo: testUserId)
          .limit(5)
          .get();
      expect(snapshot.docs.length, greaterThanOrEqualTo(1));
      // Add more assertions based on Firestore data retrieval logic
    });
  });
}
