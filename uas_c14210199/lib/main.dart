import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_c14210199/PinLoginPage.dart';
import 'package:uas_c14210199/model/note.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('pinBox');
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS_C14210199',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Pinloginpage(),
    );
  }
}
