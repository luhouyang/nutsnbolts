import 'package:flutter/material.dart';
import 'package:nutsnbolts/pages/route_page.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => UserUsecase(),
        ),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: RoutePage()),
    );
  }
}
