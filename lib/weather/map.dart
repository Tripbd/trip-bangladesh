import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NewGoogleMaps extends StatefulWidget {
  @override
  _NewGoogleMapsState createState() => _NewGoogleMapsState();
}

class _NewGoogleMapsState extends State<NewGoogleMaps> {
  GoogleMapController mapController;
  String searchAddress;

  _openMap() async {
    const url = "https://www.google.com/maps";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(23.777176, 90.399452), zoom: 10),
          ),
          Positioned(
            top: 50,
            right: 15,
            left: 15,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tap to Search here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 15),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _openMap,
                    iconSize: 30,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAddress = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
