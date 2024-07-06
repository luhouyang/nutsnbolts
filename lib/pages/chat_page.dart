import 'package:flutter/material.dart';
import 'package:nutsnbolts/entities/case_entity.dart';

class ChatPage extends StatefulWidget {
  final CaseEntity caseEntity;

  const ChatPage({super.key, required this.caseEntity});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.caseEntity.toMap().toString()),
          Image.network(widget.caseEntity.publicImageLink)
        ],
      ),
    );
  }
}
