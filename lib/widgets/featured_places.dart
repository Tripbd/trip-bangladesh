import 'package:Trip_bangladesh/blocs/featured_bloc.dart';
import 'package:Trip_bangladesh/models/place.dart';
import 'package:Trip_bangladesh/pages/place_details.dart';
import 'package:Trip_bangladesh/utils/loading_cards.dart';
import 'package:Trip_bangladesh/utils/next_screen.dart';
import 'package:Trip_bangladesh/widgets/custom_cache_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Featured extends StatefulWidget {
  Featured({Key key}) : super(key: key);

  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  int listIndex = 2;

  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: DotsIndicator(
            dotsCount: 5,
            position: listIndex.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black12,
              activeColor: Colors.black45,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(10.0, 4.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 260,
          width: w,
          child: PageView.builder(
            controller: PageController(initialPage: 2),
            scrollDirection: Axis.horizontal,
            itemCount: fb.data.isEmpty ? 1 : fb.data.length,
            onPageChanged: (index) {
              setState(() {
                listIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              if (fb.data.isEmpty) return LoadingFeaturedCard();
              return _FeaturedItemList(d: fb.data[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedItemList extends StatelessWidget {
  final Place d;
  const _FeaturedItemList({Key key, @required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: w,
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'featured${d.timestamp}',
              child: Container(
                  height: 220,
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCacheImage(imageUrl: d.imageUrl1))),
            ),
            Positioned(
              height: 70,
              width: MediaQuery.of(context).size.width,
              bottom: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          d.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              d.location,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          nextScreen(
              context, PlaceDetails(data: d, tag: 'featured${d.timestamp}'));
        },
      ),
    );
  }
}
