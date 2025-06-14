import 'package:chat_app/home_page.dart';
import 'package:chat_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // from flutterfire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(0, 202, 255, 1),
          primary: Color.fromRGBO(0, 202, 255, 1),
        ),

        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.black,
          )
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIconColor: Color.fromARGB(90, 0, 202, 255),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            height: 1,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          )
        ),

      ),
      home: SignIn(),
    );
  }
}