import 'package:flutter/material.dart';
import 'package:nutsnbolts/widgets/my_text_field.dart';

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
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          MyTextField(hint: "case title", validator: textVerify, controller: caseTitleController),
          ElevatedButton(onPressed: () {}, child: const Text("submit"))
        ],
      ),
    );
  }

  String textVerify(value) {
    return value != null ? "" : "Please enter a valid input";
  }
}
