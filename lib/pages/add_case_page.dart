import 'package:flutter/material.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/testdata/test_data.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  TextEditingController caseTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserUsecase>(
        builder: (context, userUsecase, child) {
          return Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              MyTextField(hint: "case title", validator: textVerify, controller: caseTitleController),
              ElevatedButton(
                  onPressed: () async {
                    await FirestoreModel().addCase(TestData.caseEntity, userUsecase);
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
