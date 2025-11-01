import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/home_page/home_screen.dart';
import 'package:todo_list/hive_db/hive_db.dart';

void main() async {
  //   Flutter bindings ready for async code / Hive
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Hive for Flutter
  await Hive.initFlutter();

  //  Register the Hive Adapter (for Data model)
  Hive.registerAdapter(DataAdapter());


  await Hive.openBox<Data>('todoBox');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: HomeScreen(),
    ),
  ));
}
