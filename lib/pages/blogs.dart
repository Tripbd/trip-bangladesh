import 'package:Trip_bangladesh/blocs/blog_bloc.dart';
import 'package:Trip_bangladesh/models/blog.dart';
import 'package:Trip_bangladesh/pages/blog_details.dart';
import 'package:Trip_bangladesh/utils/empty.dart';
import 'package:Trip_bangladesh/utils/loading_cards.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:Trip_bangladesh/widgets/custom_cache_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  BlogPage({Key key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'loves';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<BlogBloc>().getData(mounted, _orderBy);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<BlogBloc>();

    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<BlogBloc>().setLoading(true);
        context.read<BlogBloc>().getData(mounted, _orderBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bb = context.watch<BlogBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('blogs').tr(),
        elevation: 0,
        actions: <Widget>[],
      ),
      body: RefreshIndicator(
        child: bb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(icon: Feather.map, message: 'Empty', message1: ''),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.all(15),
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: bb.data.length != 0 ? bb.data.length + 1 : 20,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 20,
                ),
                // shrinkWrap: true,
                itemBuilder: (_, int index) {
                  if (index < bb.data.length) {
                    return _ItemList(d: bb.data[index]);
                  }
                  return Opacity(
                    opacity: bb.isLoading ? 1.0 : 0.0,
                    child: bb.lastVisible == null
                        ? LoadingCard(height: 250)
                        : Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CupertinoActivityIndicator()),
                          ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<BlogBloc>().onRefresh(mounted, _orderBy);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemList extends StatelessWidget {
  final Blog d;
  const _ItemList({Key key, @required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          child: Wrap(
            children: [
              Hero(
                tag: 'blog${d.timestamp}',
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(imageUrl: d.thumbnailImagelUrl)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => nextScreen(
            context, BlogDetails(blogData: d, tag: 'blog${d.timestamp}')));
  }
}
