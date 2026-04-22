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
import 'package:b2bmobile/utils/categories.dart';
import 'package:b2bmobile/utils/map_style.dart';
import 'package:b2bmobile/Screens/pages/search_page.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Position? currentPosition;
  List<DetailItem> _allItems = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.locationWhenInUse.status;

    if (permissionStatus.isDenied) {
      PermissionStatus newPermissionStatus = await Permission.locationWhenInUse.request();
      if (newPermissionStatus.isGranted) {
        getCurrentLocation();
        fetchMapItems();
      } else {
        fetchMapItems(); // Still fetch items even if location denied
      }
    } else {
      getCurrentLocation();
      fetchMapItems();
    }
  }

  void fetchMapItems() async {
    try {
      final collections = ['businesses', 'events', 'userresourcesupport', 'youthresource', 'supportbusinesses'];
      List<DetailItem> items = [];
      
      for (String coll in collections) {
        final snapshot = await FirebaseFirestore.instance
            .collection(coll)
            .where('isVerified', isEqualTo: true)
            .get();
            
        for (var doc in snapshot.docs) {
          final data = doc.data();
          try {
            if (coll == 'businesses') {
              items.add(Business.fromMap(data).toDetailItem());
            } else if (coll == 'events') {
              items.add(Events.fromMap(data).toDetailItem());
            } else {
              items.add(Support.fromMap(data).toDetailItem());
            }
          } catch (e) {
            debugPrint("Error parsing map item ${doc.id} in $coll: $e");
          }
        }
      }

      if (mounted) {
        setState(() {
          _allItems = items;
        });
        _updateMarkers();
      }
    } catch (e) {
      debugPrint("Error fetching map items: $e");
    }
  }

  void _updateMarkers() {
    Set<Marker> newMarkers = {};

    for (var item in _allItems) {
      if (item.latitude != 0.0 && item.longitude != 0.0) {
        // Filter by category
        if (_selectedCategory != 'All' && item.category != _selectedCategory) {
          continue;
        }

        final latLng = LatLng(item.latitude, item.longitude);
        double hue = item.isBlackOwned ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueRed;

        newMarkers.add(Marker(
          markerId: MarkerId(item.id),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          onTap: () {
            _showItemOptions(item);
            mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
          },
        ));
      }
    }
    
    // Add current location marker if available
    if (currentPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
  }

  void _showItemOptions(DetailItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                     width: 80,
                     height: 80,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(16),
                       color: const Color(0xFF1E1E1E),
                       image: item.imageUrl.isNotEmpty
                          ? DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover)
                          : null,
                     ),
                     child: item.imageUrl.isEmpty ? const Icon(Icons.store, color: Colors.white30, size: 30) : null,
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Text(
                               item.category.isEmpty ? "Directory" : item.category.toUpperCase(),
                               style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                             ),
                             const Spacer(),
                             if (item.isBlackOwned)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('PREMIUM', style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                           ],
                         ),
                         const SizedBox(height: 4),
                         Text(
                           item.name,
                           style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                         const SizedBox(height: 4),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Icon(Icons.location_on, color: Colors.white38, size: 14),
                             const SizedBox(width: 4),
                             Expanded(
                               child: Text(
                                 item.address,
                                 style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12),
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        _launchMaps(item.latitude, item.longitude);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2A2A2A))),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.directions, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Directions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.to(() => UniversalDetailScreen(item: item));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.white, Color(0xFFC0C0C0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('Explore Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
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
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });
      _updateMarkers(); // Add location marker
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 12),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPosition?.latitude ?? 39.8283, currentPosition?.longitude ?? -98.5795), // US Center fallback
              zoom: currentPosition != null ? 12.0 : 4.0, 
            ),
            style: darkMapStyle,
            markers: markers,
            myLocationEnabled: false, // We control the icon
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (currentPosition != null) {
                 mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(LatLng(currentPosition!.latitude, currentPosition!.longitude), 12)
                 );
              }
            },
          ),
          
          // Custom Gradient Overlay Top
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
          
          // Search & Categories Strip
          Positioned(
            top: 50, left: 0, right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const SearchPage()),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: const Color(0xFF1E1E1E).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white12)),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white54, size: 20),
                                const SizedBox(width: 12),
                                Text('Discover Excellence...', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: ['All', ...appCategories].length,
                    itemBuilder: (context, index) {
                      final cat = ['All', ...appCategories][index];
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                          _updateMarkers();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFF1E1E1E).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.white : Colors.white12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat, 
                            style: GoogleFonts.outfit(
                              color: isSelected ? Colors.black : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Current Location Button
          Positioned(
            bottom: 30, right: 20,
            child: GestureDetector(
              onTap: () {
                if (currentPosition != null) {
                  mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(LatLng(currentPosition!.latitude, currentPosition!.longitude), 12),
                  );
                } else {
                   getCurrentLocation();
                }
              },
              child: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), shape: BoxShape.circle, border: Border.all(color: Colors.white12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4))]),
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
