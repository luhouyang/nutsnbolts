import 'package:flutter/material.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:nutsnbolts/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  TextEditingController caseTitleController = TextEditingController();
  TextEditingController caseDescController = TextEditingController();
  TextEditingController moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> controllers = {
      CaseEntityAttr.caseTitle.value: caseTitleController,
      CaseEntityAttr.caseDesc.value: caseDescController,
      CaseEntityAttr.clientPrice.value: moneyController
    };

    return Scaffold(
      body: Consumer<UserUsecase>(
        builder: (context, userUsecase, child) {
          return Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              MyTextField(hint: "case title", validator: textVerify, controller: caseTitleController),
              MyTextField(hint: "case description", validator: textVerify, controller: caseDescController),
              MyMoneyTextField(controller: moneyController),
              ElevatedButton(
                  onPressed: () async {
                    await FirestoreModel().addCase(controllers, userUsecase).then(
                      (value) {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text("submit"))
            ],
          );
        },
      ),
    );
  }

  String textVerify(value) {
    return value != null ? "" : "Please enter a valid input";
  }
}
