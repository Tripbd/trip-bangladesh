import 'package:Trip_bangladesh/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;

  void _logIn({String email, String password}) {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }).catchError((err) {
      print(err.code);
      if (err.code == 'Error Wrong Password') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('This Password is incorrect. Please try again'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('ok'),
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
        child: Container(
          padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  'Log In',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              TextField(
                  onChanged: (textVal) {
                    setState(() {
                      email = textVal;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.check),
                      hintText: 'Your Email',
                      labelText: 'Your Email',
                      labelStyle: TextStyle(fontWeight: FontWeight.w400))),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                  onChanged: (textVal) {
                    setState(() {
                      password = textVal;
                    });
                  },
                  obscureText: true,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      suffixText: 'Forget',
                      hintText: 'Password',
                      labelText: 'Password',
                      labelStyle: TextStyle(fontWeight: FontWeight.w400))),
              SizedBox(
                height: 30.0,
              ),
              InkWell(
                onTap: () {
                  _logIn(email: email, password: password);
                },
                child: Container(
                  height: 35,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Or sign up with Social account',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
