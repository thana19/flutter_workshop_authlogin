import 'package:flutter/material.dart';
import 'package:flutter_workshoptest/pages/EditProfilePage.dart';
import 'package:flutter_workshoptest/pages/HomePage.dart';
import 'package:flutter_workshoptest/pages/LoginPage.dart';
import 'package:flutter_workshoptest/pages/RegisterPage.dart';
import 'package:flutter_workshoptest/pages/Launcher.dart';
import 'package:flutter_workshoptest/pages/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Workshop1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // '/': (context) => LoginPage(),
        '/': (context) => token == null ? LoginPage() : Launcher(),
        "/home": (context) => HomePage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/profile": (context) => ProfilePage(),
        "/editprofile": (context) => EditProfilePage(),
        "/launcher": (context) => Launcher(),
      },
    );
  }
}
