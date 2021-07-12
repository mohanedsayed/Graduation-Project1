import 'package:arrziclone/screens/auth/login/login_screen.dart';
import 'package:arrziclone/screens/auth/signup/widgets/or_divider.dart';
import 'package:arrziclone/screens/auth/signup/widgets/social_icon.dart';
import 'package:arrziclone/screens/auth/wrapper.dart';
import 'package:arrziclone/screens/home/employer/Employer_home_screen.dart';
import 'package:arrziclone/services/auth_helper.dart';
import 'package:arrziclone/widgets/already_have_accountcheck.dart';
import 'package:arrziclone/widgets/rounded_button.dart';
import 'package:arrziclone/widgets/rounded_inputfield.dart';
import 'package:arrziclone/widgets/rounded_passwordfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "SIGNUP",
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
              hintText: "Your Email",
              controller: _emailController,
              // onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: _passwordController,
              // onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: _confirmpasswordController,
              // onChanged: (value) {},
              confirmedpassword: true,
            ),
            RoundedButton(
              text: "SIGNUP",
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
                if (_confirmpasswordController.text.isEmpty ||
                    _confirmpasswordController.text !=
                        _passwordController.text) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Alert'),
                        content:
                            Text('Confirm Password don\'t match the Password'),
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
                  final user = await AuthHelper.signUpWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (user != null) {
                    print("signup successful");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SocalIcon(
                //   iconSrc: "assets/icons/facebook.svg",
                //   press: () {},
                // ),
                // SocalIcon(
                //   iconSrc: "assets/icons/twitter.svg",
                //   press: () {},
                // ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
