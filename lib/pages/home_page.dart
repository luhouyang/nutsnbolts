import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserUsecase>(
      builder: (context, userUsecase, child) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userUsecase.userEntity.uid)
              .collection('cases')
              .orderBy('casePosted', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                CaseEntity caseEntity = CaseEntity.from(snapshot.data!.docs[index].data());
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseEntity.caseTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(caseEntity.clientName), Text(caseEntity.clientPhoneNo)],
                        ),
                        Text(caseEntity.caseDesc),
                        Text("posted on: ${DateFormat.yMEd().add_jms().format(caseEntity.casePosted.toDate())}"),
                        Text("lat: ${caseEntity.caseLocation.latitude.toString()} long: ${caseEntity.caseLocation.longitude.toString()}")
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
