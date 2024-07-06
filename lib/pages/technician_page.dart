import 'package:flutter/material.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/testdata/test_data.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:provider/provider.dart';

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key});

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  TextEditingController moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    CaseEntity caseEntity = TestData.caseEntity;

    return Column(
      children: [
        MyMoneyTextField(controller: moneyController),
        ElevatedButton(
            onPressed: () async {
              await FirestoreModel().addBid(moneyController.text, userUsecase, caseEntity).then(
                (value) {
                },
              );
            },
            child: const Text("mememememe"))
      ],
    );
  }
}
