import 'package:flutter/material.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("add case"),
    );
  }
}
