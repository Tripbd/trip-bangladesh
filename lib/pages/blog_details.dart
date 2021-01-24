import 'package:Trip_bangladesh/blocs/ads_bloc.dart';
import 'package:Trip_bangladesh/blocs/bookmark_bloc.dart';
import 'package:Trip_bangladesh/blocs/sign_in_bloc.dart';
import 'package:Trip_bangladesh/models/blog.dart';
import 'package:Trip_bangladesh/pages/comments.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:Trip_bangladesh/utils/sign_in_dialog.dart';
import 'package:Trip_bangladesh/widgets/bookmark_icon.dart';
import 'package:Trip_bangladesh/widgets/custom_cache_image.dart';
import 'package:Trip_bangladesh/widgets/love_count.dart';
import 'package:Trip_bangladesh/widgets/love_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetails extends StatefulWidget {
  final Blog blogData;
  final String tag;

  BlogDetails({Key key, @required this.blogData, @required this.tag})
      : super(key: key);

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  final String collectionName = 'blogs';

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onLoveIconClick(collectionName, widget.blogData.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onBookmarkIconClick(collectionName, widget.blogData.timestamp);
    }
  }

  handleSource(link) async {
    if (await canLaunch(link)) {
      launch(link);
    }
  }

  handleShare() {}

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.watch<SignInBloc>();
    final Blog d = widget.blogData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Hero(
                  tag: widget.tag,
                  child: Container(
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CustomCacheImage(
                              imageUrl: d.thumbnailImagelUrl))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                              icon: BuildLoveIcon(
                                  collectionName: collectionName,
                                  uid: sb.uid,
                                  timestamp: d.timestamp),
                              onPressed: () {
                                handleLoveClick();
                              }),
                          IconButton(
                              icon: BuildBookmarkIcon(
                                  collectionName: collectionName,
                                  uid: sb.uid,
                                  timestamp: d.timestamp),
                              onPressed: () {
                                handleBookmarkClick();
                              }),
                          Spacer(),
                          FlatButton.icon(
                              color: Colors.white,
                              onPressed: () {
                                nextScreen(
                                    context,
                                    CommentsPage(
                                        collectionName: collectionName,
                                        timestamp: d.timestamp));
                              },
                              icon: Icon(Icons.message),
                              label: Text('comments').tr())
                        ],
                      ),
                      LoveCount(
                          collectionName: collectionName,
                          timestamp: d.timestamp),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Text(
                  d.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800]),
                ),
                SizedBox(
                  height: 15,
                ),
                Html(
                    defaultTextStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800]),
                    data: '''  ${d.description}   '''),
                SizedBox(
                  height: 30,
                )
              ]),
        ),
      ),
    );
  }
}
