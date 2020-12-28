import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/Screens/login.dart';
import 'package:rider_app/Screens/mainScreen.dart';
import 'package:rider_app/main.dart';

class RegisterScreen extends StatelessWidget {
  static const String idScreen = 'register';

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              "Register as a Rider",
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
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
                              "Register",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (nameTextEditingController.text.isEmpty &&
                              emailTextEditingController.text.isEmpty &&
                              passwordTextEditingController.text.isEmpty &&
                              phoneTextEditingController.text.isEmpty) {
                            displayToastMsg(
                                "Please Fil up all the details..", context);
                          } else if (nameTextEditingController.text.length <
                              3) {
                            displayToastMsg(
                                "Name must 3 characters long.", context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMsg("Email Must Contains @.", context);
                          } else if (phoneTextEditingController.text.isEmpty) {
                            displayToastMsg(
                                "Please Enter your number.", context);
                          } else if (passwordTextEditingController.text.length <
                              6) {
                            displayToastMsg(
                                "Password must be 7 characters long.", context);
                            registerNewUser(context);
                          }
                        })
                  ],
                )),
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text('Already have an account? Login here..'))
          ]),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMsg('Error Message' + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) // user created
    {
      // save user info yto database

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim()
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMsg(
          "Woah! Your account has been created, Happy Ride.", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      // throw an error message
      displayToastMsg("User has not been created.", context);
    }
  }
}

displayToastMsg(String msg, BuildContext context) {
  Fluttertoast.showToast(
    msg: msg,
    fontSize: 15.0,
  );
}
