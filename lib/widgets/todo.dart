import 'package:Trip_bangladesh/config/config.dart';
import 'package:Trip_bangladesh/models/place.dart';
import 'package:Trip_bangladesh/pages/comments.dart';
import 'package:Trip_bangladesh/pages/guide.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

class TodoWidget extends StatelessWidget {
  final Place placeData;
  const TodoWidget({Key key, @required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    LineIcons.map_marker,
                    size: 30,
                  ),
                ),
                Text(
                  'Location',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ).tr(),
              ])),
          onTap: () => nextScreen(context, GuidePage(d: placeData)),
        ),
        Spacer(),
        InkWell(
          child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        LineIcons.comments,
                        size: 30,
                      ),
                    ),
                    Text(
                      'Comments',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ).tr(),
                  ])),
          onTap: () => nextScreen(
              context,
              CommentsPage(
                collectionName: 'places',
                timestamp: placeData.timestamp,
              )),
        ),
        Spacer(),
        InkWell(
            child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          LineIcons.share,
                          size: 30,
                        ),
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ).tr(),
                    ])),
            onTap: () {
              var widget;
              Share.share(
                  ' ${Config().appName} To read more install app link');
            })
      ],
    );
  }
}
