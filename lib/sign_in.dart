import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

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

  
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  var eMailText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/img4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
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
                      'SignIn',
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
                    Row(
                      children: [
                        Text(
                          eMailText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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
                    Row(
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        if(isValidEmail(eMailId.text) == false) {
                          setState(() {
                            eMailText = 'Invalid E-Mail ID';
                          });
                        } else {
                          setState(() {
                            eMailText = '';
                          });
                          var message = 'Password reset mail sent.';
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: eMailId.text);
                          } on FirebaseAuthException catch (e) {
                            message = e.toString();
                            message = 'This E-Mail is not registered with us.';
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
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password ?',
                            
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(isValidEmail(eMailId.text) == false) {
                            setState(() {
                              eMailText = 'Invalid E-Mail ID';
                            });
                          } else {
                            setState(() {
                              eMailText = '';
                            });
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
                          'Sign In',
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
                          'Don\'t have an account? ',
                          style: TextTheme.of(context).labelLarge,
                        ),
                        GestureDetector(
                          onTap: widget.onSwitch,
                          child: Text(
                            'Register',
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
        ],
      ),
    );
  }
}