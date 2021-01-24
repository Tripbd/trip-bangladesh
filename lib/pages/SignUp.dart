import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'LoginPage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password, passwordConfirm;
  bool saveAttempted = false;
  final formKey = GlobalKey<FormState>();

  void _createUser({String email, String password}) {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authResult) {
      print('success ${authResult.user}');
    }).catchError((err) {
      print(err.code);
      if (err.code == 'email-already-in-use') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'This email already has an account associated with it'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  TextFormField(
                      // ignore: deprecated_member_use
                      autovalidate: true,
                      onChanged: (textValue) {
                        setState(() {
                          email = textValue;
                        });
                      },
                      validator: (emailValue) {
                        if (emailValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        String p =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                        RegExp regExp = new RegExp(p);
                        if (regExp.hasMatch(emailValue)) {
                          return null;
                        }
                        return 'This is not a valid email';
                      },
                      style: TextStyle(fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.check),
                          hintText: 'Your Email',
                          labelText: 'Your Email',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400))),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      // ignore: deprecated_member_use
                      autovalidate: true,
                      onChanged: (textValue) {
                        setState(() {
                          password = textValue;
                        });
                      },
                      validator: (passwordValue) {
                        if (passwordValue.isEmpty) {
                          return 'This field is mandatory';
                        }
                        if (passwordValue.length < 6) {
                          return 'Password must be 6 Character';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400))),
                  TextFormField(
                      // ignore: deprecated_member_use
                      autovalidate: true,
                      onChanged: (textValue) {
                        setState(() {
                          passwordConfirm = textValue;
                        });
                      },
                      validator: (passwordConfirmValue) {
                        if (passwordConfirmValue != password) {
                          return 'Password must match';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400))),
                  SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        saveAttempted = true;
                      });
                      if (formKey.currentState.validate())
                        formKey.currentState.save();
                      _createUser(email: email, password: password);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 40),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Log In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'By signing up you agree to our ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Terms of Use',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'and ',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Privicy Policy',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
