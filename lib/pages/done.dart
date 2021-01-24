import 'package:Trip_bangladesh/pages/intro.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:flutter/material.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key key}) : super(key: key);

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000))
        .then((value) => nextScreenCloseOthers(context, IntroPage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
