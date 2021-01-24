import 'package:Trip_bangladesh/blocs/featured_bloc.dart';
import 'package:Trip_bangladesh/blocs/popular_places_bloc.dart';
import 'package:Trip_bangladesh/blocs/recent_places_bloc.dart';
import 'package:Trip_bangladesh/blocs/recommanded_places_bloc.dart';
import 'package:Trip_bangladesh/blocs/sign_in_bloc.dart';
import 'package:Trip_bangladesh/blocs/sp_state_one.dart';
import 'package:Trip_bangladesh/blocs/sp_state_two.dart';
import 'package:Trip_bangladesh/config/config.dart';
import 'package:Trip_bangladesh/pages/search.dart';
import 'package:Trip_bangladesh/widgets/featured_places.dart';
import 'package:Trip_bangladesh/widgets/popular_places.dart';
import 'package:Trip_bangladesh/widgets/recent_places.dart';
import 'package:Trip_bangladesh/widgets/recommended_places.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  Explore({Key key}) : super(key: key);

  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      context.read<FeaturedBloc>().getData();
      context.read<PopularPlacesBloc>().getData();
      context.read<RecentPlacesBloc>().getData();
      context.read<SpecialStateOneBloc>().getData();
      context.read<SpecialStateTwoBloc>().getData();
      context.read<RecommandedPlacesBloc>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<FeaturedBloc>().onRefresh();
              context.read<PopularPlacesBloc>().onRefresh(mounted);
              context.read<RecentPlacesBloc>().onRefresh(mounted);
              context.read<SpecialStateOneBloc>().onRefresh(mounted);
              context.read<SpecialStateTwoBloc>().onRefresh(mounted);
              context.read<RecommandedPlacesBloc>().onRefresh(mounted);
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Header(),
                  Featured(),
                  PopularPlaces(),
                  RecentPlaces(),
                  RecommendedPlaces()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      Config().appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800]),
                    ),
                  ),
                  Text(
                    'Explore the nature',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ).tr()
                ],
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'search places',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ).tr(),
                    Icon(
                      Feather.search,
                      color: Colors.black12,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Config().appName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              Text(
                'Explore ${Config().countryName}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              )
            ],
          ),
          Spacer(),
          IconButton(
              icon: Icon(
                Feather.bell,
                size: 20,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Feather.search,
                size: 20,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
