import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/Screens/pages/business detal/business_detail_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
    try {
      final businessesSnapshot = await FirebaseFirestore.instance
          .collection('businesses')
          .where('isVerified', isEqualTo: true)
          .get();

      setState(() {
        markers = businessesSnapshot.docs.map((document) {
          final data = document.data();
          // Safely deserialize
          Business business;
          try {
             business = Business.fromMap(data);
          } catch (e) {
             debugPrint("Error parsing business ${document.id}: $e");
             return null;
          }

          if (business.latitude != 0.0 && business.longitude != 0.0) {
            final latLng = LatLng(business.latitude, business.longitude);

            return Marker(
              markerId: MarkerId(document.id),
              position: latLng,
              infoWindow: InfoWindow(
                title: business.businessName,
                snippet: "Tap for options",
                onTap: () {
                  _showBusinessOptions(business);
                }
              ),
            );
          }
          return null;
        }).whereType<Marker>().toSet(); // Filter out nulls
      });
    } catch (e) {
      debugPrint("Error fetching businesses: $e");
    }
  }

  void _showBusinessOptions(Business business) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                business.businessName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(business.businessAddress),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton.icon(
                    onPressed: () {
                      _launchMaps(business.latitude, business.longitude);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Navigate"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                       Get.to(() => BusinessDetailScreen(business: business));
                    },
                    icon: const Icon(Icons.info),
                    label: const Text("Details"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _launchMaps(double lat, double lng) async {
    final googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      debugPrint("Could not launch maps.");
    }
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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 14),
      );
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
                currentPosition?.latitude ?? 37.0902, // Default US
                currentPosition?.longitude ?? -95.7129,
              ),
              zoom: currentPosition != null ? 14.0 : 4.0, 
            ),
            markers: markers,
            myLocationEnabled: true, // Shows blue dot if permission granted
            myLocationButtonEnabled: false, // We use custom button
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (currentPosition != null) {
                 mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(currentPosition!.latitude, currentPosition!.longitude), 14)
                 );
              }
            },
          ),
          Positioned(
            top: 40,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
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
                } else {
                   getCurrentLocation();
                }
              },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
