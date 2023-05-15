import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_recorder/speech_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AskMate Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SpeechScreen());
  }
}
