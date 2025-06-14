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
      home: AuthGate(),
    );
  }
}

class AuthStateService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream that emits the current user and updates when:
  /// - auth state changes (sign in/out)
  /// - email is verified
  Stream<User?> get authAndEmailVerifiedChanges async* {
    // Yield current user initially
    yield _auth.currentUser;

    // Listen to auth state changes
    await for (final user in _auth.authStateChanges()) {
      yield user;

      // If signed in, check for email verification every 3 seconds
      if (user != null && !user.emailVerified) {
        await for (final _ in Stream.periodic(Duration(seconds: 3))) {
          await user.reload(); // reload user from Firebase
          final refreshedUser = _auth.currentUser;

          if (refreshedUser != null && refreshedUser.emailVerified) {
            yield refreshedUser; // emit updated user
            break; // stop checking
          }
        }
      }
    }
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthStateService().authAndEmailVerifiedChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null || user.emailVerified == false) {
          return SignIn();
        }

        return HomePage();
      },
    );
  }
}
