import 'package:arrziclone/constants.dart';
import 'package:arrziclone/screens/auth/signup/signup_screen.dart';
import 'package:arrziclone/screens/auth/signup/widgets/or_divider.dart';
import 'package:arrziclone/screens/auth/signup/widgets/social_icon.dart';
import 'package:arrziclone/screens/auth/welcome/welcome_screen.dart';
import 'package:arrziclone/screens/home/employer/Employer_home_screen.dart';
import 'package:arrziclone/services/auth_helper.dart';
import 'package:arrziclone/widgets/already_have_accountcheck.dart';
import 'package:arrziclone/widgets/rounded_button.dart';
import 'package:arrziclone/widgets/rounded_inputfield.dart';
import 'package:arrziclone/widgets/rounded_passwordfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../wrapper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Text(
              'ARRZI',
              style: TextStyle(
                fontSize: textSizeXXLarge,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            RoundedInputField(
              controller: _emailController,
              hintText: "Your Email",
              // onChanged: (value) {
              // },
            ),
            RoundedPasswordField(
              // onChanged: (value) {},
              controller: _passwordController,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  print("Email and password cannot be empty");
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Email and password cannot be empty'),
                        content: Text('Here we go'),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                try {
                  final user = await AuthHelper.signInWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (user != null) {
                    print("login successful");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                    );
                    // return WelcomeScreen();
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error:'),
                        content: Text(e),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  print("errror : $e");
                }
              },
            ),
            SizedBox(height: 10.0),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {
                    try {
                      AuthHelper.signInWithGoogle();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
