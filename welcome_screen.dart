import 'package:arrziclone/constants.dart';
import 'package:arrziclone/screens/auth/login/login_screen.dart';
import 'package:arrziclone/screens/auth/signup/signup_screen.dart';
import 'package:arrziclone/screens/auth/wrapper.dart';
import 'package:arrziclone/screens/home/employer/Employer_home_screen.dart';
import 'package:arrziclone/screens/home/worker/worker_home_screen.dart';
import 'package:arrziclone/services/auth_helper.dart';
import 'package:arrziclone/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //This is when the user is already logged in
        if (snapshot.hasData && snapshot.hasData != null) {
          UserHelper.saveUser(snapshot.data);
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(snapshot.data.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData && snapshot.hasData != null) {
                final user = snapshot.data.data();
                if (user['role'] == 'worker') {
                  return WorkerHomeScreen();
                } else if (user['role'] == 'employer') {
                  return EmployerHomeScreen();
                } else {
                  return Wrapper();
                }
              }
              return Material(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
        // return LoginScreen();
        // this return the welcome screen if the user in null
        return Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              //
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 50.0,
                ),
                child: SizedBox(
                  // height: 55,
                  child: Text(
                    'ARRZI',
                    style: TextStyle(
                      fontSize: textSizeXXLarge,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "LOGIN",
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
              RoundedButton(
                text: "SIGN UP",
                color: Colors.red[50],
                textColor: Colors.black,
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
            ],
          ),
        ));
      },
    );
  }
}
