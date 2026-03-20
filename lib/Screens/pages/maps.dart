import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/models/detail_item.dart';
import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
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
        fetchMapItems();
      }
    } else if (permissionStatus.isGranted) {
      // Permission already granted. Fetch businesses and current location.
      getCurrentLocation();
      fetchMapItems();
    }
  }

  void fetchMapItems() async {
    try {
      final collections = [
        'businesses',
        'events',
        'userresourcesupport',
        'youthresource',
        'supportbusinesses'
      ];
      
      Set<Marker> newMarkers = {};
      
      for (String coll in collections) {
        final snapshot = await FirebaseFirestore.instance
            .collection(coll)
            .where('isVerified', isEqualTo: true)
            .get();
            
        for (var doc in snapshot.docs) {
          final data = doc.data();
          DetailItem? item;
          try {
            if (coll == 'businesses') {
              item = Business.fromMap(data).toDetailItem();
            } else if (coll == 'events') {
              item = Events.fromMap(data).toDetailItem();
            } else {
              item = Support.fromMap(data).toDetailItem();
            }
          } catch (e) {
            debugPrint("Error parsing map item ${doc.id} in $coll: $e");
            continue;
          }

          if (item.latitude != 0.0 && item.longitude != 0.0) {
            final latLng = LatLng(item.latitude, item.longitude);
            
            // Set different marker colours based on type if you wish (Hue)
            double hue = BitmapDescriptor.hueRed;
            if (coll == 'events') {
              hue = BitmapDescriptor.hueBlue;
            } else if (coll != 'businesses') {
              hue = BitmapDescriptor.hueGreen;
            }

            newMarkers.add(Marker(
              markerId: MarkerId(doc.id),
              position: latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              infoWindow: InfoWindow(
                title: item.name,
                snippet: "Tap for options",
                onTap: () {
                  _showItemOptions(item!);
                }
              ),
            ));
          }
        }
      }

      if (mounted) {
        setState(() {
          markers = newMarkers;
        });
      }
    } catch (e) {
      debugPrint("Error fetching map items: $e");
    }
  }

  void _showItemOptions(DetailItem item) {
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
                item.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                item.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton.icon(
                    onPressed: () {
                      _launchMaps(item.latitude, item.longitude);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Navigate"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                       Get.to(() => UniversalDetailScreen(item: item));
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
