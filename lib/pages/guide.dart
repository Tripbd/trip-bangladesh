import 'dart:async';
import 'dart:typed_data';

import 'package:Trip_bangladesh/blocs/ads_bloc.dart';
import 'package:Trip_bangladesh/config/config.dart';
import 'package:Trip_bangladesh/models/place.dart';
import 'package:Trip_bangladesh/utils/convert_map_icon.dart';
import 'package:Trip_bangladesh/utils/map_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geo/geo.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class GuidePage extends StatefulWidget {
  final Place d;
  GuidePage({Key key, @required this.d}) : super(key: key);

  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  GoogleMapController mapController;

  _openMap() async {
    const url = "https://www.google.com/maps";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }

  List<Marker> _markers = [];
  Map data = {};
  String distance = 'O km';

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Uint8List _sourceIcon;
  Uint8List _destinationIcon;

  Future getData() async {
    await FirebaseFirestore.instance
        .collection('places')
        .doc(widget.d.timestamp)
        .collection('travel guide')
        .doc(widget.d.timestamp)
        .get()
        .then((DocumentSnapshot snap) {
      setState(() {
        data = snap.data();
      });
    });
  }

  _setMarkerIcons() async {
    _sourceIcon = await getBytesFromAsset(Config().drivingMarkerIcon, 110);
    _destinationIcon =
        await getBytesFromAsset(Config().destinationMarkerIcon, 110);
  }

  Future addMarker() async {
    List m = [
      Marker(
          markerId: MarkerId(data['startpoint name']),
          position: LatLng(data['startpoint lat'], data['startpoint lng']),
          infoWindow: InfoWindow(title: data['startpoint name']),
          icon: BitmapDescriptor.fromBytes(_sourceIcon)),
      Marker(
          markerId: MarkerId(data['endpoint name']),
          position: LatLng(data['endpoint lat'], data['endpoint lng']),
          infoWindow: InfoWindow(title: data['endpoint name']),
          icon: BitmapDescriptor.fromBytes(_destinationIcon))
    ];
    setState(() {
      m.forEach((element) {
        _markers.add(element);
      });
    });
  }

  Future computeDistance() async {
    var p1 = geo.LatLng(data['startpoint lat'], data['startpoint lng']);
    var p2 = geo.LatLng(data['endpoint lat'], data['endpoint lng']);
    double _distance = geo.computeDistanceBetween(p1, p2) / 1000;
    setState(() {
      distance = '${_distance.toStringAsFixed(2)} km';
    });
  }

  Future _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Config().mapAPIKey,
      PointLatLng(data['startpoint lat'], data['startpoint lng']),
      PointLatLng(data['endpoint lat'], data['endpoint lng']),
      travelMode: TravelMode.bicycling,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void animateCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(data['startpoint lat'], data['startpoint lng']),
        zoom: 8,
        bearing: 120)));
  }

  void onMapCreated(controller) {
    controller.setMapStyle(MapUtils.mapStyles);
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });
    _setMarkerIcons();
    getData().then((value) => addMarker().then((value) {
          _getPolyline();
          computeDistance();
          animateCamera();
        }));
  }

  Widget panelUI() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Trip Guide",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ).tr(),
          ],
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                text: 'estimated cost = '.tr(),
                children: <TextSpan>[
              TextSpan(
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  text: data['price'])
            ])),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                text: 'distance = '.tr(),
                children: <TextSpan>[
              TextSpan(
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  text: distance)
            ])),
      ],
    );
  }

  Widget panelBodyUI(h, w) {
    return Container(
      width: w,
      child: GoogleMap(
        initialCameraPosition: Config().initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => onMapCreated(controller),
        markers: Set.from(_markers),
        polylines: Set<Polyline>.of(polylines.values),
        compassEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return new Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        SlidingUpPanel(
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
            backdropEnabled: true,
            backdropOpacity: 0.2,
            backdropTapClosesPanel: true,
            isDraggable: false,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[400], blurRadius: 0, offset: Offset(1, 0))
            ],
            padding: EdgeInsets.only(top: 15, left: 10, bottom: 0, right: 10),
            panel: panelUI(),
            body: panelBodyUI(h, w)),
        Positioned(
          top: 15,
          left: 10,
          child: Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 10,
                              offset: Offset(3, 3))
                        ]),
                    child: Icon(Icons.keyboard_backspace),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                data.isEmpty
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 0.5)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, bottom: 10, right: 15),
                          child: Text(
                            '${data['startpoint name']} - ${data['endpoint name']}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          height: 600,
          padding: EdgeInsets.only(right: 10),
          child: FloatingActionButton(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: Icon(
                Icons.map,
                color: Colors.white70,
              ),
            ),
            onPressed: _openMap,
          ),
        ),
        data.isEmpty && polylines.isEmpty
            ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container()
      ]),
    ));
  }
}
