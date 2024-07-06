import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/env/env.dart';

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
    _fetchAnalysis();
  }

  Future<void> _fetchAnalysis() async {
    final url =
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.caseEntity.toMap().toString()),
                    Image.network(widget.caseEntity.publicImageLink),
                    SizedBox(height: 20),
                    if (apiResponse != null)
                      Text(apiResponse!)
                    else
                      CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
