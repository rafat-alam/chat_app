import 'package:chat_app/home_page.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/sign_up.dart';
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
  /// - Auth state changes (sign in/out)
  /// - Email is verified
  Stream<User?> get authAndEmailVerifiedChanges async* {
    yield _auth.currentUser;

    await for (final user in _auth.authStateChanges()) {
      yield user;

      if (user != null && !user.emailVerified) {
        await for (final _ in Stream.periodic(Duration(seconds: 3))) {
          await user.reload();
          final refreshedUser = _auth.currentUser;

          if (refreshedUser != null && refreshedUser.emailVerified) {
            yield refreshedUser;
            break;
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
      stream: AuthStateService().authAndEmailVerifiedChanges
          .distinct((a, b) => a?.uid == b?.uid && a?.emailVerified == b?.emailVerified),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null || !user.emailVerified) {
          return const AuthScreen();
        }

        return const HomePage();
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignIn = true;

  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(onSwitch: toggle)
        : SignUp(onSwitch: toggle);
  }
}
