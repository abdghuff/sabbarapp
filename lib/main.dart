import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sabbar1/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:sabbar1/screens/authenticate/login_screen.dart';
import 'package:sabbar1/services/auth.dart';
import 'Home_Screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sabbar',
        theme: ThemeData(primarySwatch: Colors.lightGreen, fontFamily: 'Tajawal'),
        home: Directionality(
        textDirection: TextDirection.rtl,
        child: LoginScreen(),
      ),
      debugShowCheckedModeBanner: false,
      );
  }
}
