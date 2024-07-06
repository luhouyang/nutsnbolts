import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutsnbolts/env/env.dart';
import 'package:nutsnbolts/firebase_options.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:provider/provider.dart';
import 'package:nutsnbolts/pages/auth_page.dart';

void main() async {
  // Make sure Flutter is fully initialized then load firebase options
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // OPENAI API Stuff Setup
  OpenAI.apiKey = Env.apiKey;
  OpenAI.requestsTimeOut = const Duration(seconds: 60); // 60 seconds.
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
          theme: ThemeData(fontFamily: 'RobotoCondensed'),
          debugShowCheckedModeBanner: false,
          home: const AuthGate()),
    );
  }
}
