import 'package:Trip_bangladesh/blocs/ads_bloc.dart';
import 'package:Trip_bangladesh/blocs/notification_bloc.dart';
import 'package:Trip_bangladesh/pages/blogs.dart';
import 'package:Trip_bangladesh/pages/bookmark.dart';
import 'package:Trip_bangladesh/pages/explore.dart';
import 'package:Trip_bangladesh/pages/profile.dart';
import 'package:Trip_bangladesh/pages/states.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'drawar_menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<IconData> iconList = [
    Feather.home,
    Feather.bookmark,
    Feather.map,
    Feather.clipboard,
    Feather.user
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(milliseconds: 400));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      await context
          .read<NotificationBloc>()
          .initFirebasePushNotification(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    context.read<AdsBloc>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        inactiveColor: Colors.black,
        activeColor: Colors.red,
        onTap: (index) => onTabTapped(index),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Explore(),
          BookmarkPage(),
          BlogPage(),
          StatesPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
