import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Verification Mail
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Current user
  User? get currentUser => _auth.currentUser;
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController eMailId = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SignUp',
                style: TextTheme.of(context).titleLarge,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 1,
                controller: eMailId,
                decoration: InputDecoration(
                  hintText: 'Email ID',
                  border: OutlineInputBorder(

                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 1,
                controller: pass,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(

                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final auth = AuthService();
                  final User? user = await auth.signUp(eMailId.text, pass.text);
                  if(user != null && user.emailVerified == false) {
                    await auth.sendEmailVerification();
                  }
                  if(user != null && user.emailVerified) {
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'E-Mail Used / Not Verified',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: Text(
                            'E-Mail is aready used or Verification link has been sent to your Email. Please verify it.',
                            // style: Theme.of(context).textTheme.titleMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await auth.sendEmailVerification();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  'Sign Up',
                  style: TextTheme.of(context).bodySmall,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}