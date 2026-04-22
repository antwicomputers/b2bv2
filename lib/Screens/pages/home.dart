import 'package:carousel_slider/carousel_slider.dart';
import 'package:b2bmobile/services/config_service.dart';

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
import 'package:b2bmobile/Screens/pages/b2b_service_board.dart';
import 'package:b2bmobile/models/business.dart';
import 'package:b2bmobile/widgets/premium_business_card.dart';
import 'package:b2bmobile/services/matchmaking_service.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:b2bmobile/utils/categories.dart';
import 'all_women.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    
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
            colors: [Color(0xFF0A0A0A), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ─── HEADER ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BLACK',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'DIGITAL WALL STREET',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: const Color(0xFFC0C0C0),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                    // Notification Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: const Icon(Icons.notifications_none_rounded,
                          color: Color(0xFFC0C0C0), size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // ─── SPONSOR CAROUSEL (Hero) ──────────────────────────────
            _SponsorCarousel(
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance
                          .collection('businesses')
                          .where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isSponsored', isEqualTo: true)
                  .where('isVerified', isEqualTo: true)
                  .snapshots(),
              size: size,
              isHero: true,
            ),

            // ─── SEARCH BAR ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: GestureDetector(
                  onTap: () => Get.to(() => const SearchPage()),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: Color(0xFFC0C0C0), size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Explore Premium Network...',
                          style: GoogleFonts.outfit(
                              color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── CATEGORY PILLS ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: ['All', ...appCategories].length,
                    itemBuilder: (context, index) {
                      final cat = ['All', ...appCategories][index];
                      return _CategoryChip(
                        label: cat,
                        isSelected: _selectedCategory == cat,
                        onTap: () => setState(() => _selectedCategory = cat),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ─── DIVIDER ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.06))),
                  ],
                ),
              ),
            ),

            // ─── AI MATCHMAKING ───────────────────────────────────────
            _MatchmakingSection(size: size),

            // ─── B2B SERVICE BOARD BANNER ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: GestureDetector(
                  onTap: () => Get.to(() => const B2BServiceBoard()),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A1F3A), Color(0xFF0D1022)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'B2B SERVICE BOARD',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Find Elite\nService Partners',
                                style: GoogleFonts.bebasNeue(
                                  color: Colors.white,
                                  fontSize: 24,
                                  letterSpacing: 1.0,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Post an RFP. Let verified services pitch you.',
                                style: GoogleFonts.outfit(
                                    color: Colors.white54, fontSize: 12, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.arrow_forward_ios,
                              color: Colors.blueAccent, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── WOMEN FOUNDED ────────────────────────────────────────
            _BusinessSection(
              title: 'Women Founded',
              subtitle: "Edwina's Move Her Forward Initiative",
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance
                          .collection('businesses')
                          .where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('womenOriented', isEqualTo: true)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllWomen()),
              size: size,
            ),

            // ─── ESSENTIAL SERVICES ───────────────────────────────────
            _BusinessSection(
              title: 'Essential Services',
              subtitle: 'Community Support & Daily Needs',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance
                          .collection('businesses')
                          .where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('isEsential', isEqualTo: true)
                  .limit(20)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllEssential()),
              size: size,
            ),

            // ─── FEATURED BRANDS ──────────────────────────────────────
            _BusinessSection(
              title: 'Featured Brands',
              subtitle: 'Handpicked Highlights',
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance
                          .collection('businesses')
                          .where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .where('isFeatured', isEqualTo: true)
                  .limit(20)
                  .snapshots(),
              onShowAll: () => Get.to(() => const AllFeatured()),
              size: size,
            ),

            // ─── MORE TO EXPLORE GRID ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC0C0C0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MORE TO EXPLORE',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 20,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Handpicked just for you',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: (_selectedCategory == 'All'
                      ? FirebaseFirestore.instance.collection('businesses')
                      : FirebaseFirestore.instance
                          .collection('businesses')
                          .where('businessCategory', isEqualTo: _selectedCategory))
                  .where('isVerified', isEqualTo: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
                final docs = snapshot.data!.docs;
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final business = Business.fromMap(
                            docs[index].data() as Map<String, dynamic>);
                        return PremiumBusinessCard(
                            item: business.toDetailItem(),
                            size: size,
                            isGrid: true);
                      },
                      childCount: docs.length,
                    ),
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

// ─── MATCHMAKING SECTION ─────────────────────────────────────────────────────

class _MatchmakingSection extends StatelessWidget {
  const _MatchmakingSection({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userModel;

    if (user == null) return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HANDPICKED FOR YOU',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 20,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'AI-powered recommendations',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.auto_awesome,
                    color: Colors.blueAccent, size: 18),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: FutureBuilder<List<Business>>(
              future: MatchmakingService().getPersonalizedRecommendations(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _HorizontalShimmer();
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) return const SizedBox.shrink();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: items.length,
                  itemBuilder: (ctx, index) {
                    final business = items[index];
                    return PremiumBusinessCard(
                        item: business.toDetailItem(), size: size);
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

// ─── CATEGORY CHIP ───────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.label,
      this.isSelected = false,
      required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC0C0C0) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC0C0C0)
                : const Color(0xFF2A2A2A),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFFC0C0C0),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─── BUSINESS SECTION ────────────────────────────────────────────────────────

class _BusinessSection extends StatelessWidget {
  const _BusinessSection({
    required this.title,
    required this.subtitle,
    required this.stream,
    required this.onShowAll,
    required this.size,
  });

  final String title;
  final String subtitle;
  final Stream<QuerySnapshot> stream;
  final VoidCallback onShowAll;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC0C0C0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.bebasNeue(
                            fontSize: 20,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onShowAll,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Text(
                      'VIEW ALL',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: const Color(0xFFC0C0C0),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 190,
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
                    return PremiumBusinessCard(
                        item: business.toDetailItem(), size: size);
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

// ─── HORIZONTAL SHIMMER ──────────────────────────────────────────────────────

class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        width: 150,
        margin: const EdgeInsets.only(right: 14, top: 8, bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
      ),
    );
  }
}

// ─── SPONSOR CAROUSEL ────────────────────────────────────────────────────────

class _SponsorCarousel extends StatelessWidget {
  const _SponsorCarousel({required this.stream, required this.size, this.isHero = false});
  final Stream<QuerySnapshot> stream;
  final Size size;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(isHero ? 0 : 0, isHero ? 16 : 28, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC0C0C0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PREMIUM SPONSORS',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Back 2 Black Official Partners',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: Colors.white38,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const AllSponsors()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: Text(
                        'VIEW ALL',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: const Color(0xFFC0C0C0),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }
                final docs = snapshot.data!.docs;
                final items = docs
                    .map((doc) => Business.fromMap(
                        doc.data() as Map<String, dynamic>))
                    .toList();

                return CarouselSlider.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index, realIndex) {
                    return PremiumBusinessCard(
                      item: items[index].toDetailItem(),
                      size: size,
                      isGrid: true,
                    );
                  },
                  options: CarouselOptions(
                    height: isHero ? 220 : 200,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 1500),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    viewportFraction: size.width < 400 ? 0.8 : 0.7,
                    scrollDirection: Axis.horizontal,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
