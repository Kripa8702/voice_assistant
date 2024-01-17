import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voice_assistant/home_page.dart';
import 'package:voice_assistant/pallete.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allen',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
