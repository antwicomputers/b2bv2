import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:get/get.dart';
import '../../models/business.dart';
import 'business detal/business_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Algolia algolia = const Algolia.init(
    applicationId: '7ID12WNW47',
    apiKey: 'a505630b1ad41820d77a530672338433',
  );

  final TextEditingController _searchController = TextEditingController();
  List<AlgoliaObjectSnapshot> _results = [];
  bool _isSearching = false;

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _results.clear();
    });

    AlgoliaQuery searchQuery =
        algolia.instance.index('b2b_businesses').query(query);
    AlgoliaQuerySnapshot querySnapshot = await searchQuery.getObjects();

    setState(() {
      _isSearching = false;
      _results = querySnapshot.hits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search B2B Database'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _performSearch(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _results.isEmpty
                    ? const Center(
                        child: Text('No Results Found'),
                      )
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          AlgoliaObjectSnapshot result = _results[index];
                          Map<String, dynamic> data = result.data;
                          String businessName = data['businessName'] ?? '';
                          String address = data['address'] ?? '';
                          String city = data['city'] ?? '';

                          Business business = Business.fromMap(data);

                          return ListTile(
                            title: Text(businessName),
                            onTap: () {
                              Get.to(() =>
                                  BusinessDetailScreen(business: business));
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(address),
                                Text(city),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
