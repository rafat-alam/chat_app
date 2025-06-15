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
  final VoidCallback onSwitch;

  const SignUp({
    super.key,
    required this.onSwitch,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _obscureText = true;

  final TextEditingController eMailId = TextEditingController();
  final TextEditingController pass = TextEditingController();

  final border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromRGBO(225, 225, 225, 1),
    ),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(15),
      right: Radius.circular(15),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox()
                ),
                Text(
                  'SignUp',
                  style: TextTheme.of(context).titleLarge,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  maxLines: 1,
                  controller: eMailId,
                  decoration: InputDecoration(
                    hintText: 'Email ID',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    prefixIcon: Icon(
                      Icons.email
                    )
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: pass,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    prefixIcon: Icon(
                      Icons.password
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 1,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextTheme.of(context).bodySmall,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox()
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextTheme.of(context).labelLarge,
                    ),
                    GestureDetector(
                      onTap: widget.onSwitch,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}