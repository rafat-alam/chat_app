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

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Length check
    if (password.length < 8 || password.length > 30) return false;

    // Regex pattern checks
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  String getPasswordValidationMessage(String password) {
    if (password.length < 8) {
      return "Password must be at least 8 characters long.";
    }

    if (password.length > 30) {
      return "Password must not exceed 30 characters.";
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter.";
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return "Password must contain at least one number.";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character.";
    }

    return "Valid password.";
  }

  var eMailText = '';
  var passText = '';

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
                          passText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '',
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
                          }
                          if(isValidPassword(pass.text) == false) {
                            setState(() {
                              passText = getPasswordValidationMessage(pass.text);
                            });
                          } else {
                            setState(() {
                              passText = '';
                            });
                          }
                          if(!(isValidEmail(eMailId.text) == false || isValidPassword(pass.text) == false)) {
                            final auth = AuthService();
                            var user = await auth.signUp(eMailId.text, pass.text);
                            if(user == null) {
                              user = await auth.signIn(eMailId.text, pass.text);
                              if(user != null && user.emailVerified) {
                                user = null;
                              }
                            }
                            if(user != null && user.emailVerified == false) {
                              await auth.sendEmailVerification();
                            }
                            var dialogTitle = 'Verification';
                            var dialogBody = 'Verification mail has been sent to your respected E-Mail address';
                            if(user == null) {
                              dialogTitle = 'E-Mail Used';
                              dialogBody = 'E-Mail used, we have an account with this E-Mail ID. Try to Sign In';
                            }
                            showDialog(
                              context: context,
                              builder: (context) {
                                if(dialogTitle == 'Verification') {
                                  return AlertDialog(
                                    title: Text(
                                      dialogTitle,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    content: Text(
                                      dialogBody,
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
                                          try {
                                            await auth.sendEmailVerification();
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Try again later. Email already sent recently.'),
                                              ),
                                            );
                                          }
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
                                } else {
                                  return AlertDialog(
                                    title: Text(
                                      dialogTitle,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    content: Text(
                                      dialogBody,
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
                                    ],
                                  );
                                }
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
        ],
      ),
    );
  }
}