import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(43.653225, -79.383186);

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;
  Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: currentLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          addMarker('test', currentLocation);
        },
        markers: _markers.values.toSet(),
      ),
    );
  }

  addMarker(String id, LatLng location) {
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: const InfoWindow(
            title: 'Title of Place', snippet: 'some description of place'));
    _markers[id] = marker;
    setState(() {});
  }
}
