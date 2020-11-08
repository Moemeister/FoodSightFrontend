import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//TODO: hacer que los mapas se actualicen según el cardview

class MapRestaurantLocation extends StatefulWidget {
  final String locationCoords;

  MapRestaurantLocation(this.locationCoords);

  @override
  State<MapRestaurantLocation> createState() =>
      MapRestaurantLocationState(locationCoords);
}

class MapRestaurantLocationState extends State<MapRestaurantLocation> {
  final String coords;
  static String staticCoords;

  MapRestaurantLocationState(this.coords) {
    staticCoords = coords;
  }

  Completer<GoogleMapController> _controller = Completer();

  static var latlong = staticCoords.split(",");

  static double lat = double.parse(latlong[0]);
  static double long = double.parse(latlong[1]);

  Set<Marker> _markers = {};
  static BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    //TODO: Usar icono mas grande
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/icons/icons8-next-location-24.png');
  }

  static CameraPosition cameraPosition = CameraPosition(
    target: LatLng(lat, long),
    zoom: 15.5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          setState(() {
            _markers.add(Marker(
                markerId: MarkerId('<MARKER_ID>'),
                position: LatLng(lat, long),
                icon: pinLocationIcon));
          });
        },
        compassEnabled: true,
      ),
    );
  }
}
