import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
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
}

class SignIn extends StatefulWidget {
  final VoidCallback onSwitch;

  const SignIn({
    super.key,
    required this.onSwitch,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final TextEditingController eMailId = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SignIn',
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
              GestureDetector(
                onTap: () async {
                  var message = 'Password reset mail sent.';
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: eMailId.text);
                  } on FirebaseAuthException catch (e) {
                    message = 'Please enter a valid email';
                  }
                  // if(message == 'Password reset mail sent.') {
                  //   try {
                  //     await FirebaseAuth.instance.signInWithEmailAndPassword(email: eMailId.text, password: 'kk@12Akk');
                  //   } on FirebaseAuthException catch (e) {
                  //     if (e.code == 'user-not-found') {
                  //       message = 'User not found.';
                  //     }
                  //   }
                  // }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password ?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final auth = AuthService();
                  final User? user = await auth.signIn(eMailId.text, pass.text);
                  var message = 'Successfully Login.';
                  if(user == null) {
                    message = 'Incorrect E-Mail or Password';
                  } else if(user.emailVerified == false) {
                    message = 'Please verify your Email';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                      ),
                    ),
                  );
                  if(user != null && user.emailVerified == false) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Verification',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: Text(
                            'Verification link has been sent to your Email. Please verify it.',
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
                  'Sign In',
                  style: TextTheme.of(context).bodySmall,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not have an account? ',
                    style: TextTheme.of(context).labelLarge,
                  ),
                  GestureDetector(
                    onTap: widget.onSwitch,
                    child: Text(
                      'Register',
                      style: TextTheme.of(context).bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}