import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hhotel/screens/menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Room Service',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.teal,
          backgroundColor: Colors.grey[100],
          accentColor: Colors.teal[300]),
      home: const Menu(),
    );
  }
}
