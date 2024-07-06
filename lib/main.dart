// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:nutsnbolts/env/env.dart';
import 'package:nutsnbolts/firebase_options.dart';
import 'package:nutsnbolts/pages/auth_page.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';

void main() async {
  // Make sure Flutter is fully initialized then load firebase options
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // OpenAI API Setup
  OpenAI.apiKey = Env.apiKey;
  OpenAI.requestsTimeOut = const Duration(seconds: 60);
  OpenAI.showLogs = true;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserUsecase(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(fontFamily: 'RobotoCondensed'), // Set default font
          debugShowCheckedModeBanner: false, // Disable debug banner
          home: const AuthGate()),
    );
  }
}
