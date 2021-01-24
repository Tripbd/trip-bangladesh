import 'package:Trip_bangladesh/models/place.dart';
import 'package:Trip_bangladesh/pages/place_details.dart';
import 'package:Trip_bangladesh/pages/search.dart';
import 'package:Trip_bangladesh/utils/loading_cards.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:Trip_bangladesh/widgets/custom_cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';

class MorePlacesPage extends StatefulWidget {
  final String title;
  final Color color;
  MorePlacesPage({Key key, @required this.title, @required this.color})
      : super(key: key);

  @override
  _MorePlacesPageState createState() => _MorePlacesPageState();
}

class _MorePlacesPageState extends State<MorePlacesPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'places';
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = new List<DocumentSnapshot>();
  List<Place> _data = [];
  bool _descending;
  String _orderBy;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    if (widget.title == 'popular') {
      _orderBy = 'loves';
      _descending = true;
    } else if (widget.title == 'recommended') {
      _orderBy = 'comments count';
      _descending = true;
    } else {
      _orderBy = 'timestamp';
      _descending = false;
    }
    _getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
    });
    _getData();
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy(_orderBy, descending: _descending)
          .limit(5)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .orderBy(_orderBy, descending: _descending)
          .startAfter([_lastVisible[_orderBy]])
          .limit(5)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Place.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
    return null;
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                )
              ],
              backgroundColor: Colors.white,
              expandedHeight: 20,
            ),
            SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _data.length) {
                      return _ListItem(
                        d: _data[index],
                        tag: '${widget.title}$index',
                      );
                    }
                    return Opacity(
                      opacity: _isLoading ? 1.0 : 0.0,
                      child: _lastVisible == null
                          ? Column(
                              children: [
                                LoadingCard(
                                  height: 180,
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            )
                          : Center(
                              child: SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: new CupertinoActivityIndicator()),
                            ),
                    );
                  },
                  childCount: _data.length == 0 ? 5 : _data.length + 1,
                ),
              ),
            )
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Place d;
  final tag;
  const _ListItem({Key key, @required this.d, @required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 10),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                          offset: Offset(0, 3))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        child: Hero(
                          tag: tag,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              child: CustomCacheImage(imageUrl: d.imageUrl1)),
                        )),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Feather.map_pin,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Text(
                                  d.location,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                LineIcons.heart,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                d.loves.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                LineIcons.comment,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                d.commentsCount.toString(),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          onTap: () => nextScreen(context, PlaceDetails(data: d, tag: tag)),
        ),
      ],
    );
  }
}
