import 'package:arrziclone/screens/home/employer/Employer_home_screen.dart';
import 'package:arrziclone/screens/home/worker/worker_home_screen.dart';
import 'package:arrziclone/services/auth_helper.dart';
import 'package:arrziclone/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Do You Want To Work \n Or Hire ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
              SizedBox(height: 90.0),
              Text(
                'ARRZI',
                style: TextStyle(
                  fontSize: textSizeXXLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Image.asset(
              //   "assets/images/welcome.png",
              //   height: size.height * 0.45,
              // ),
              SizedBox(height: 50.0),
              CustomButton(
                text: 'Employer',
                outlinebtn: true,
                onpressed: () {
                  final User user = auth.currentUser;
                  UserHelper.UpdateUserRole(user, "employer");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployerHomeScreen(),
                    ),
                  );
                },
              ),
              CustomButton(
                outlinebtn: false,
                text: 'Worker',
                onpressed: () {
                  final User user = auth.currentUser;
                  UserHelper.UpdateUserRole(user, "worker");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerHomeScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
