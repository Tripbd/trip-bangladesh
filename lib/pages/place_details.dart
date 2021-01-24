import 'package:Trip_bangladesh/blocs/ads_bloc.dart';
import 'package:Trip_bangladesh/blocs/bookmark_bloc.dart';
import 'package:Trip_bangladesh/blocs/sign_in_bloc.dart';
import 'package:Trip_bangladesh/models/place.dart';
import 'package:Trip_bangladesh/utils/sign_in_dialog.dart';
import 'package:Trip_bangladesh/widgets/bookmark_icon.dart';
import 'package:Trip_bangladesh/widgets/comment_count.dart';
import 'package:Trip_bangladesh/widgets/custom_cache_image.dart';
import 'package:Trip_bangladesh/widgets/love_count.dart';
import 'package:Trip_bangladesh/widgets/love_icon.dart';
import 'package:Trip_bangladesh/widgets/other_places.dart';
import 'package:Trip_bangladesh/widgets/todo.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PlaceDetails extends StatefulWidget {
  final Place data;
  final String tag;

  const PlaceDetails({Key key, @required this.data, @required this.tag})
      : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });
  }

  String collectionName = 'places';

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onLoveIconClick(collectionName, widget.data.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onBookmarkIconClick(collectionName, widget.data.timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.watch<SignInBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: widget.tag,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      height: 370,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Carousel(
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.pink,
                          showIndicator: true,
                          dotSize: 2,
                          dotSpacing: 10,
                          boxFit: BoxFit.cover,
                          images: [
                            CustomCacheImage(imageUrl: widget.data.imageUrl1),
                            CustomCacheImage(imageUrl: widget.data.imageUrl2),
                            CustomCacheImage(imageUrl: widget.data.imageUrl3),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 15,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.white38.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          LineIcons.arrow_left,
                          color: Colors.black45,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.data.name,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey[800])),
                      Spacer(),
                      IconButton(
                          icon: BuildLoveIcon(
                              collectionName: collectionName,
                              uid: sb.uid,
                              timestamp: widget.data.timestamp),
                          onPressed: () {
                            handleLoveClick();
                          }),
                      IconButton(
                          icon: BuildBookmarkIcon(
                              collectionName: collectionName,
                              uid: sb.uid,
                              timestamp: widget.data.timestamp),
                          onPressed: () {
                            handleBookmarkClick();
                          }),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: Text(
                        widget.data.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                      LoveCount(
                          collectionName: collectionName,
                          timestamp: widget.data.timestamp),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.sms_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      CommentCount(
                          collectionName: collectionName,
                          timestamp: widget.data.timestamp)
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Html(
                    data: '''${widget.data.description}''',
                    defaultTextStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TodoWidget(placeData: widget.data),
                  SizedBox(
                    height: 15,
                  ),
                  OtherPlaces(
                    stateName: widget.data.state,
                    timestamp: widget.data.timestamp,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
