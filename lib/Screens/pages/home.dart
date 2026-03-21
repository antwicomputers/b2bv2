import 'dart:math';

import 'package:b2bmobile/Screens/pages/all_esential.dart';
import 'package:b2bmobile/Screens/pages/all_featured.dart';
import 'package:b2bmobile/Screens/pages/all_sponsors.dart';
import 'package:b2bmobile/Screens/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/business.dart';

import 'package:b2bmobile/utils/categories.dart';
import 'all_women.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _FavoritesState();
}

class _FavoritesState extends State<HomePage> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage:");
        if (!mounted) return;
        final snackBar =
            SnackBar(content: Text(message.notification?.title ?? ""));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F0F), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- Modern Header ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BACK 2 BLACK',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Empowering Black-Owned Businesses',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Glassmorphic Search Bar ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: GestureDetector(
                  onTap: () => Get.to(() => const SearchPage()),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Colors.white54, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          'Search businesses, events...',
                          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- Categories Quick Strip ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: ['All', ...appCategories].length,
                    itemBuilder: (context, index) {
                      final cat = ['All', ...appCategories][index];
                      return _CategoryChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

            // --- Section: Premium Sponsors ---
            _BusinessSection(
              title: 'Premium Sponsors',
              subtitle: 'Back 2 Black Official Partners',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance.collection('businesses').where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isSponsored', isEqualTo: true)
                  .where('isVerified', isEqualTo: true)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllSponsors()),
              size: size,
            ),

            // --- Section: Women Founded ---
            _BusinessSection(
              title: 'Women Founded',
              subtitle: 'Edwina\'s Move Her Forward Initiative',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance.collection('businesses').where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('womenOriented', isEqualTo: true)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllWomen()),
              size: size,
              headerColor: Colors.pinkAccent,
            ),

            // --- Section: Essential Services ---
            _BusinessSection(
              title: 'Essential Services',
              subtitle: 'Community Support & Daily Needs',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance.collection('businesses').where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('isEsential', isEqualTo: true)
                  .limit(20)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllEssential()),
              size: size,
              headerColor: Colors.orangeAccent,
            ),

            // --- Section: Featured Brands ---
            _BusinessSection(
              title: 'Featured Brands',
              subtitle: 'Handpicked Highlights',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance.collection('businesses').where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('isFeatured', isEqualTo: true)
                  .limit(20)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllFeatured()),
              size: size,
              headerColor: Colors.purpleAccent,
            ),

            // --- Section: More Businesses ---
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MORE TO EXPLORE',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 24,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Handpicked just for you',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.white38,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance.collection('businesses').where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SliverToBoxAdapter(child: SizedBox());
                final docs = snapshot.data!.docs;
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final business = Business.fromMap(docs[index].data() as Map<String, dynamic>);
                      return HomeBusinessTile(business: business, size: size, isGrid: true);
                    },
                    childCount: docs.length,
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.isSelected = false, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isSelected ? Colors.white : Colors.white10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _BusinessSection extends StatelessWidget {
  const _BusinessSection({
    required this.title,
    required this.subtitle,
    required this.stream,
    required this.onShowAll,
    required this.size,
    this.headerColor = Colors.white,
  });

  final String title;
  final String subtitle;
  final Stream<QuerySnapshot> stream;
  final VoidCallback onShowAll;
  final Size size;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.bebasNeue(
                        fontSize: 24,
                        letterSpacing: 1.2,
                        color: headerColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.white38,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onShowAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      'VIEW ALL',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _HorizontalShimmer();
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('Coming soon...',
                          style: TextStyle(color: Colors.white24)));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: docs.length,
                  itemBuilder: (ctx, index) {
                    final business = Business.fromMap(
                        docs[index].data() as Map<String, dynamic>);
                    return HomeBusinessTile(business: business, size: size);
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

class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        width: 150,
        margin: const EdgeInsets.only(right: 20, top: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class HomeBusinessTile extends StatelessWidget {
  const HomeBusinessTile({
    super.key,
    required this.business,
    required this.size,
    this.isGrid = false,
  });
  final Business business;
  final Size size;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isGrid ? 0 : 18.0, top: 4, bottom: 12),
      child: GestureDetector(
        onTap: () => Get.to(() => UniversalDetailScreen(item: business.toDetailItem())),
        child: Container(
          width: isGrid ? double.infinity : size.width * 0.4,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Framed Image ---
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    business.businessUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.business, color: Colors.white24, size: 28)),
                  ),
                ),
              ),
              // --- Modern Info Area ---
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.businessName,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.businessCategory.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (business.isVerified)
                          const Icon(Icons.verified, color: Colors.blueAccent, size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
