import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _predictions = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<List<String>> _getAddressPredictions(String input) async {
    final apiKey = 'AIzaSyADCVeLD0o5fhX2uFj6qfAnNzUlA96KJ1Q';
    final endpoint =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final requestUrl = '$endpoint?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List<dynamic>;
      return predictions
          .map((prediction) => prediction['description'] as String)
          .toList();
    } else {
      throw Exception('Failed to retrieve address predictions.');
    }
  }

  void _saveAddressToFirebase(String address) async {
    final firebaseInstance = FirebaseFirestore.instance;
    final collectionRef = firebaseInstance.collection('addresses');

    try {
      final List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final LatLng latLng =
            LatLng(locations.first.latitude, locations.first.longitude);
        final documentRef = collectionRef.doc();

        documentRef.set({
          'address': address,
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
        }).then((value) {
          print('Address saved to Firebase.');
        }).catchError((error) {
          print('Failed to save address: $error');
        });
      } else {
        print('Failed to find location for the given address.');
      }
    } catch (error) {
      print('Error occurred while retrieving location: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Prediction'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Address',
            ),
            onChanged: (value) async {
              final predictions = await _getAddressPredictions(value);
              setState(() {
                _predictions = predictions;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _predictions.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(_predictions[index]),
                  onTap: () {
                    final selectedAddress = _predictions[index];
                    _saveAddressToFirebase(selectedAddress);
                    Navigator.pop(context, selectedAddress);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
