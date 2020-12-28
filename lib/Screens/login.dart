import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/Screens/mainScreen.dart';
import 'package:rider_app/Screens/registration.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(height: 35.0),
            Image(
              image: AssetImage("assets/images/logo.png"),
              width: 400.0,
              height: 250.0,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1.0),
            Text(
              "Login as a Rider",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
            ),
            SizedBox(height: 1.0),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: passwordTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (emailTextEditingController.text.isEmpty &&
                              passwordTextEditingController.text.isEmpty) {
                            displayToastMsg(
                                "Email and Password cannot be empty.", context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMsg("Email Must Contains @.", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            displayToastMsg(
                                "Password cannot be empty.", context);
                          } else {
                            loginAndAuthUser(context);
                          }
                        })
                  ],
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterScreen.idScreen, (route) => false);
                },
                child: Text('Do not have an account? Click here..'))
          ]),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMsg('Error Message' + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) // user created
    {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          displayToastMsg("Woah! You are logged in, Happy Ride.", context);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
        } else {
          _firebaseAuth.signOut();
          displayToastMsg(
              "No record exits for this user. Create a new account!", context);
        }
      });
    } else {
      // throw an error message
      displayToastMsg("Error Occured cannot Sign In.", context);
    }
  }
}
