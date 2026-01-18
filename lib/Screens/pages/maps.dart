import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;

    if (permissionStatus.isDenied) {
      // Permission has not been granted yet. Request it.
      PermissionStatus newPermissionStatus =
          await Permission.locationWhenInUse.request();

      if (newPermissionStatus.isGranted) {
        // Permission granted. Fetch businesses and current location.
        getCurrentLocation();
        fetchBusinesses();
      }
    } else if (permissionStatus.isGranted) {
      // Permission already granted. Fetch businesses and current location.
      getCurrentLocation();
      fetchBusinesses();
    }
  }

  void fetchBusinesses() async {
    // Assuming you have already initialized Firebase
    final businessesSnapshot =
        await FirebaseFirestore.instance.collection('addresses').get();

    setState(() {
      markers = businessesSnapshot.docs.map((document) {
        final business = document.data();
        final businessAddress = business['addresses'];

        if (businessAddress != null &&
            businessAddress['latitude'] != null &&
            businessAddress['longitude'] != null) {
          final latLng = LatLng(
            businessAddress['latitude'] as double,
            businessAddress['longitude'] as double,
          );

          return Marker(
            markerId: MarkerId(document.id),
            position: latLng,
          );
        } else {
          // Handle missing or invalid latitude/longitude values
          // You can choose to skip adding the marker or use a default location
          // For example:
          // return Marker(
          //   markerId: MarkerId(document.id),
          //   position: LatLng(0, 0),
          // );
          return Marker(
            markerId: MarkerId(document.id),
            position: const LatLng(0, 0),
          );
        }
      }).toSet();
    });
  }

  void getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
          ),
        );
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentPosition?.latitude ?? 0.0,
                currentPosition?.longitude ?? 0.0,
              ),
              zoom: 14.0, // Set a reasonable zoom level
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            top: 40,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Handle current location button press
                if (currentPosition != null) {
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        zoom: 14,
                      ),
                    ),
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
