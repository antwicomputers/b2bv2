import 'package:b2bmobile/models/detail_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:b2bmobile/utils/images.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class UniversalDetailScreen extends StatefulWidget {
  const UniversalDetailScreen({super.key, required this.item});
  final DetailItem item;

  @override
  State<UniversalDetailScreen> createState() => _UniversalDetailScreenState();
}

class _UniversalDetailScreenState extends State<UniversalDetailScreen> {
  DocumentReference get _docRef => FirebaseFirestore.instance
      .collection(widget.item.firestoreCollection)
      .doc(widget.item.id);

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _toggleLike() async {
    if (_uid.isEmpty) return;
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(_docRef);
      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>;
      final liked = (data['likedBy'] as Map<String, dynamic>?)?[_uid] ?? false;
      final count = (data['likeCount'] as int?) ?? 0;
      tx.update(_docRef, {
        'likeCount': liked ? (count - 1).clamp(0, 999999) : count + 1,
        'likedBy.$_uid': !liked,
      });
    });
  }

  Future<void> _toggleFavorite() async {
    if (_uid.isEmpty) return;
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(_docRef);
      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>;
      final fav = (data['favoriteBy'] as Map<String, dynamic>?)?[_uid] ?? false;
      final count = (data['favoriteCount'] as int?) ?? 0;
      tx.update(_docRef, {
        'favoriteCount': fav ? (count - 1).clamp(0, 999999) : count + 1,
        'favoriteBy.$_uid': !fav,
      });
    });
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open ${uri.toString()}'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _docRef.snapshots(),
        builder: (context, snapshot) {
          bool isLiked = false;
          int likeCount = 0;
          bool isFavorite = false;
          int favoriteCount = 0;

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            likeCount = (data['likeCount'] as int?) ?? 0;
            favoriteCount = (data['favoriteCount'] as int?) ?? 0;
            if (_uid.isNotEmpty) {
              isLiked = (data['likedBy'] as Map<String, dynamic>?)?[_uid] ?? false;
              isFavorite = (data['favoriteBy'] as Map<String, dynamic>?)?[_uid] ?? false;
            }
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.report_gmailerrorred, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(item.imageUrl, fit: BoxFit.cover),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InteractionBadge(
                              icon: isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                              color: isLiked ? Colors.blueAccent : Colors.white,
                              count: likeCount,
                              onTap: _toggleLike,
                            ),
                            _InteractionBadge(
                              icon: isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                              color: isFavorite ? Colors.redAccent : Colors.white,
                              count: favoriteCount,
                              onTap: _toggleFavorite,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _silver.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category.toUpperCase(),
                          style: const TextStyle(color: _silver, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // --- Status Badges ---
                      Row(
                        children: [
                          if (item.isVerified)
                            _StatusBadge(
                              label: 'Verified',
                              icon: Icons.verified,
                              color: Colors.blueAccent,
                            ),
                          if (item.isSponsored)
                            _StatusBadge(
                              label: 'Sponsor',
                              icon: Icons.stars,
                              color: Colors.amberAccent,
                            ),
                          if (item.womenOriented)
                            _StatusBadge(
                              label: 'Women Owned',
                              icon: Icons.female,
                              color: Colors.pinkAccent,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 24),

                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        content: item.address,
                        isLink: true,
                        onTap: () {
                          if (item.latitude != 0.0 && item.longitude != 0.0) {
                            _launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${item.latitude},${item.longitude}'));
                          } else {
                            _launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(item.address)}'));
                          }
                        },
                      ),
                      if (item.eventDate != null) ...[
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: Icons.calendar_today_rounded,
                          content: DateFormat('EEEE, MMM d, yyyy • h:mm a').format(item.eventDate!),
                        ),
                      ],

                      const SizedBox(height: 32),
                      const Text(
                        "ABOUT",
                        style: TextStyle(color: _silverDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                      ),

                      if (item.galleryImages.isNotEmpty) ...[
                        const SizedBox(height: 40),
                        const Text(
                          "GALLERY",
                          style: TextStyle(color: _silverDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: item.galleryImages.length,
                            itemBuilder: (context, index) => Container(
                              width: 260,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white10),
                                image: DecorationImage(
                                  image: NetworkImage(item.galleryImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (item.isBlackOwned) ...[
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blueAccent.withValues(alpha: 0.1), Colors.transparent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "VERIFIED PREMIUM",
                                    style: GoogleFonts.bebasNeue(color: Colors.blueAccent, fontSize: 18, letterSpacing: 1.2),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "As a verified partner, this business or resource has been vetted by our team. Premium features like exclusive rewards and real-time shop updates coming soon.",
                                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),
                      const Text(
                        "CONNECT",
                        style: TextStyle(color: _silverDark, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          if (item.facebook.isNotEmpty) 
                            _SocialIcon(icon: Icons.facebook, onTap: () => _launchUrl(Uri.parse('https://www.facebook.com/${item.facebook}'))),
                          if (item.email.isNotEmpty) 
                            _SocialIcon(icon: Icons.email_rounded, onTap: () => _launchUrl(Uri(scheme: 'mailto', path: item.email))),
                          if (item.phone.isNotEmpty) 
                            _SocialIcon(icon: Icons.phone_rounded, onTap: () => _launchUrl(Uri.parse('tel:${item.phone}'))),
                          if (item.website.isNotEmpty) 
                            _SocialIcon(icon: Icons.language_rounded, onTap: () => _launchUrl(Uri.parse('https://${item.website}'))),
                          if (item.twitter.isNotEmpty) 
                            _SocialIcon(asset: Images.twitter, onTap: () => _launchUrl(Uri.parse('https://twitter.com/${item.twitter}'))),
                          if (item.twitch.isNotEmpty) 
                            _SocialIcon(asset: Images.twitch, onTap: () => _launchUrl(Uri.parse('https://www.twitch.tv/${item.twitch}'))),
                          if (item.tiktok.isNotEmpty) 
                            _SocialIcon(asset: Images.tiktok, onTap: () => _launchUrl(Uri.parse('https://www.tiktok.com/${item.tiktok}'))),
                          if (item.linkedIn.isNotEmpty) 
                            _SocialIcon(asset: Images.linkedin, onTap: () => _launchUrl(Uri.parse('https://www.linkedin.com/in/${item.linkedIn}'))),
                          if (item.instagram.isNotEmpty) 
                            _SocialIcon(asset: Images.instagram, onTap: () => _launchUrl(Uri.parse('https://www.instagram.com/${item.instagram}'))),
                          if (item.youtube.isNotEmpty) 
                            _SocialIcon(icon: FontAwesomeIcons.youtube, onTap: () => _launchUrl(Uri.parse(item.youtube))),
                          if (item.podcast.isNotEmpty) 
                            _SocialIcon(asset: Images.podcast, onTap: () => _launchUrl(Uri.parse(item.podcast))),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InteractionBadge extends StatelessWidget {
  const _InteractionBadge({required this.icon, required this.color, required this.count, required this.onTap});
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.content, this.isLink = false, this.onTap});
  final IconData icon;
  final String content;
  final bool isLink;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _silverDark, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                color: isLink ? _silver : Colors.white70,
                fontSize: 14,
                decoration: isLink ? TextDecoration.underline : null,
                decorationColor: _silverDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({this.icon, this.asset, required this.onTap});
  final IconData? icon;
  final String? asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: _silver, size: 28)
              : ImageIcon(AssetImage(asset!), color: _silver, size: 28),
        ),
      ),
    );
  }
}
