import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hhotel/provider/auth_bloc.dart';
import 'package:hhotel/provider/restaurant_bloc.dart';
import 'package:hhotel/screens/login_page.dart';
import 'package:hhotel/screens/menu.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
    ChangeNotifierProvider<RestaurantBloc>.value(value: RestaurantBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc _auth = Provider.of<AuthBloc>(context);

    return MaterialApp(
      title: 'Smart Room Service',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.teal,
          backgroundColor: Colors.grey[100],
          accentColor: Colors.teal[300]),
      home: _auth.isLogged ? const Menu() : const LoginPage(),
    );
  }
}
