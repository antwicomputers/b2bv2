import 'dart:async';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/models/detail_item.dart';
import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:b2bmobile/widgets/premium_business_card.dart';
import 'package:get/get.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Favorites screen — shows every item the current user has favorited,
// spanning all collections (businesses, events, support, resources, youth).
// Data structure: each doc has favoriteBy: { uid: true }
// ──────────────────────────────────────────────────────────────────────────────

enum _ItemType { business, event, support }

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  static const List<Map<String, dynamic>> _collections = [
    {'col': 'businesses', 'type': _ItemType.business},
    {'col': 'events', 'type': _ItemType.event},
    {'col': 'supportbusinesses', 'type': _ItemType.support},
    {'col': 'userresourcesupport', 'type': _ItemType.support},
    {'col': 'youthresource', 'type': _ItemType.support},
  ];

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // Merges multiple Firestore snapshots into one list, updated live
  StreamSubscription? _subscription;
  List<_FavItem> _items = [];
  final List<List<_FavItem>> _buckets = [];

  @override
  void initState() {
    super.initState();
    if (_uid.isNotEmpty) _subscribe();
  }

  void _subscribe() {
    _buckets.clear();
    _buckets.addAll(List.generate(_collections.length, (_) => []));

    for (int i = 0; i < _collections.length; i++) {
      final col = _collections[i]['col'] as String;
      final type = _collections[i]['type'] as _ItemType;
      final idx = i;

      FirebaseFirestore.instance
          .collection(col)
          .where('favoriteBy.$_uid', isEqualTo: true)
          .snapshots()
          .listen((qs) {
        final parsed = <_FavItem>[];
        for (final doc in qs.docs) {
          try {
            parsed.add(_FavItem.fromDoc(doc, col, type));
          } catch (_) {}
        }
        if (mounted) {
          setState(() {
            _buckets[idx] = parsed;
            _items = _buckets.expand((x) => x).toList();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_uid.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view favorites')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '❤️  My Favorites',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite_border, size: 60, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap ❤️ on any business, event, or resource\nto save it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, i) => PremiumBusinessCard(
                item: _items[i].detailItem,
                size: MediaQuery.of(context).size,
                isGrid: true,
              ),
            ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _FavItem {
  const _FavItem({
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.detailItem,
  });

  final String name;
  final String imageUrl;
  final _ItemType type;
  final DetailItem detailItem;

  static _FavItem fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String collection,
    _ItemType type,
  ) {
    final data = doc.data();
    if (type == _ItemType.business) {
      final b = Business.fromMap(data);
      return _FavItem(
        name: b.businessName,
        imageUrl: b.businessUrl,
        type: _ItemType.business,
        detailItem: b.toDetailItem(),
      );
    } else if (type == _ItemType.event) {
      final e = Events.fromMap(data);
      return _FavItem(
        name: e.eventName,
        imageUrl: e.eventUrl,
        type: _ItemType.event,
        detailItem: e.toDetailItem(),
      );
    } else {
      final s = Support.fromMap(data);
      return _FavItem(
        name: s.supportName,
        imageUrl: s.supportUrl,
        type: _ItemType.support,
        detailItem: s.toDetailItem(),
      );
    }
  }
}

// ── Legacy widget kept for import compatibility in older screens ───────────────

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(image,
                height: size.height * 0.2,
                width: size.width * 0.5,
                fit: BoxFit.cover),
            const SizedBox(height: 9),
            Text(title),
          ],
        ),
      ),
    );
  }
}
