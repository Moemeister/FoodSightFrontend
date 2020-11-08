import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapSetPlace extends StatefulWidget {
  final bool selectingFlag;

  GoogleMapSetPlace({this.selectingFlag});

  @override
  _GoogleMapSetPlaceState createState() =>
      _GoogleMapSetPlaceState(isSelecting: selectingFlag);
}

class _GoogleMapSetPlaceState extends State<GoogleMapSetPlace> {
  final bool isSelecting;

  _GoogleMapSetPlaceState({this.isSelecting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose restaurant's location"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(13.6811458, -89.2380617),
          zoom: 16,
        ),
      ),
    );
  }
}
