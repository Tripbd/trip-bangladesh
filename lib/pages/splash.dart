import 'package:Trip_bangladesh/blocs/sign_in_bloc.dart';
import 'package:Trip_bangladesh/config/config.dart';
import 'package:Trip_bangladesh/pages/home.dart';
import 'package:Trip_bangladesh/pages/sign_in.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _controller;

  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      sb.isSignedIn == true || sb.guestUser == true
          ? gotoHomePage()
          : gotoSignInPage();
    });
  }

  gotoHomePage() {
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.isSignedIn == true) {
      sb.getDataFromSp();
    }
    nextScreenReplace(context, HomePage());
  }

  gotoSignInPage() {
    nextScreenReplace(context, SignInPage());
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );
    _controller.forward();
    afterSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: Image(
            image: AssetImage(Config().splashIcon),
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          )),
    ));
  }
}
