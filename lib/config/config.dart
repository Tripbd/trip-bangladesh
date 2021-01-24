import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'Trip Bangladesh';
  final String mapAPIKey = 'AIzaSyCDKwAXfFjM-MWszNAkyaQXOzswhqSsVTs';
  final String countryName = 'Bangladesh';
  final String splashIcon = 'assets/images/icon.png';
  final String supportEmail = 'imran40031@gmail.com';
  final String ourWebsiteUrl = '';
  final String iOSAppId = '';

  final String specialState1 = '';
  final String specialState2 = '';

  // country lattidtue & logitude
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.777176, 90.399452),
    zoom: 12,
  );

  //google maps marker icons
  final String hotelIcon = 'assets/images/hotel.png';
  final String restaurantIcon = 'assets/images/restaurant.png';
  final String hotelPinIcon = 'assets/images/hotel_pin.png';
  final String restaurantPinIcon = 'assets/images/restaurant_pin.png';
  final String drivingMarkerIcon = 'assets/images/driving_pin.png';
  final String destinationMarkerIcon =
      'assets/images/destination_map_marker.png';

  //Intro images
  final String introImage1 = 'assets/images/travel4.png';
  final String introImage2 = 'assets/images/travel2.png';
  final String introImage3 = 'assets/images/travel6.png';

  //Language Setup

  final List<String> languages = ['English', 'Bangla'];

  final int userClicksAmountsToShowEachAd = 5;

  final String admobAppId = '';
  final String admobInterstitialAdId = '';
}
