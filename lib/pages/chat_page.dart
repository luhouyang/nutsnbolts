// Dart imports
import 'dart:convert';

// Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:http/http.dart' as http;

// Local project imports
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/entities/message_entity.dart';
import 'package:nutsnbolts/env/env.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final CaseEntity caseEntity;

  const ChatPage({super.key, required this.caseEntity});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? apiResponse;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchAnalysis() async {
    const url =
        'https://api.openai.com/v1/chat/completions'; // Assuming this is the correct endpoint
    final apiKey = Env.apiKey;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  'You are an analysis AI that aims to take a look at common household problems like broken appliances or tech support problems and suggest a suitable price to charge whoever needs the aforementioned problem fixed. Output what you think the estimated price range it will cost to fix the issue. Output your prices in MYR. Do not suggest how to fix the issue.',
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': widget.caseEntity.publicImageLink,
                'detail': 'high',
              },
            },
          ],
        },
      ],
      'temperature': 0.7,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          apiResponse =
              jsonDecode(response.body)['choices'][0]['message']['content'];
        });
        MessageEntity messageEntity = MessageEntity(
            userId: "",
            userName: "",
            text: apiResponse!,
            createdAt: Timestamp.fromDate(DateTime.now()));
        await FirestoreModel()
            .updateChat(messageEntity, widget.caseEntity.caseId);
      } else {
        setState(() {
          apiResponse = 'Failed to fetch analysis: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    ChatUser user1 = ChatUser(
      id: '1',
      firstName: userUsecase.userEntity.uid == widget.caseEntity.clientId
          ? widget.caseEntity.clientName
          : widget.caseEntity.technicianName,
    );
    ChatUser assistant = ChatUser(
      id: '2',
      firstName: "Cotton Picker",
    );
    ChatUser user2 = ChatUser(
      id: '3',
      firstName: userUsecase.userEntity.uid == widget.caseEntity.clientId
          ? widget.caseEntity.technicianName
          : widget.caseEntity.clientName,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('cases')
                .doc(widget.caseEntity.caseId)
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.beat(
                    size: 60,
                    color: Colors.amber,
                  ),
                );
              }
              List<MessageEntity> messageEntityList = [];
              if (snapshot.data!.docs.isNotEmpty) {
                for (var element in snapshot.data!.docs) {
                  messageEntityList.add(MessageEntity.fromMap(element.data()));
                }
              } else {
                _fetchAnalysis();
              }

              List<ChatMessage> messages = <ChatMessage>[
                ChatMessage(
                    user: assistant,
                    createdAt: widget.caseEntity.casePosted.toDate(),
                    medias: <ChatMedia>[
                      ChatMedia(
                          url: widget.caseEntity.publicImageLink,
                          fileName: widget.caseEntity.imageLink,
                          type: MediaType.image)
                    ])
              ];
              for (MessageEntity msg in messageEntityList) {
                if (msg.userId.isNotEmpty) {
                  messages.add(ChatMessage(
                      text: msg.text,
                      user: userUsecase.userEntity.uid ==
                              widget.caseEntity.clientId
                          ? user1
                          : user2,
                      createdAt: msg.createdAt.toDate()));
                } else {
                  messages.add(ChatMessage(
                      text: msg.text,
                      user: assistant,
                      createdAt: msg.createdAt.toDate()));
                }
              }

              messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return DashChat(
                currentUser: user1,
                onSend: (ChatMessage m) {
                  MessageEntity messageEntity = MessageEntity(
                      userId: userUsecase.userEntity.uid,
                      userName: userUsecase.userEntity.userName,
                      text: m.text,
                      createdAt: Timestamp.fromDate(DateTime.now()));
                  FirestoreModel()
                      .updateChat(messageEntity, widget.caseEntity.caseId);
                  // setState(() {
                  //   messages.insert(0, m);
                  // });
                },
                messages: messages,
              );
            },
          ),

          // child: SingleChildScrollView(
          //   physics: const NeverScrollableScrollPhysics(),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Image.network(widget.caseEntity.publicImageLink),
          //       Text("Title: ${widget.caseEntity.caseDesc}"),

          //       // Text(widget.caseEntity.toMap().toString()),
          //       // Image.network(widget.caseEntity.publicImageLink),
          //       // const SizedBox(height: 20),
          //       // if (apiResponse != null) Text(apiResponse!) else const CircularProgressIndicator(),
          //     ],
          //   ),
          // ),
        ));
  }
}
