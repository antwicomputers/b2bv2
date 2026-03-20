import 'package:b2bmobile/Screens/pages/the_creator.dart';
import 'package:b2bmobile/userresources/user_resources_landing.dart';
import 'package:b2bmobile/youthresource/youth_resource_landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/Screens/business/register_business.dart';
import 'package:b2bmobile/Screens/drawer/black_kick_start.dart';
import 'package:b2bmobile/Screens/drawer/mental_health.dart';
import 'package:b2bmobile/Screens/drawer/new_events.dart';
import 'package:b2bmobile/Screens/drawer/women.dart';
import 'package:b2bmobile/Screens/business/my_businesses.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Menu & Categories',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2C2C2E), Color(0xFF000000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _CategoryCard(
                  image: 'assets/register.jpg',
                  title: 'Register Business',
                  icon: Icons.add_business_rounded,
                  onTap: () => Get.to(() => const RegisterBusiness()),
                ),
                _CategoryCard(
                  image: 'assets/register.jpg',
                  title: 'My Businesses',
                  icon: Icons.business_center_rounded,
                  onTap: () => Get.to(() => const MyBusinesses()),
                ),
                _CategoryCard(
                  image: 'assets/womentile.jpeg',
                  title: "Women Empowerment",
                  subtitle: 'Powered by Edwina',
                  icon: Icons.woman_rounded,
                  onTap: () => Get.to(() => const WomenBusiness()),
                ),
                _CategoryCard(
                  image: 'assets/mentaltile.jpeg',
                  title: 'Essential Services',
                  icon: Icons.emergency_rounded,
                  onTap: () => Get.to(() => const MentalHealth()),
                ),
                _CategoryCard(
                  image: 'assets/bks.jpeg',
                  title: 'Black KickStart',
                  icon: Icons.rocket_launch_rounded,
                  onTap: () => Get.to(() => const BlackKickStart()),
                ),
                _CategoryCard(
                  image: 'assets/resources.jpeg',
                  title: 'Resources',
                  icon: Icons.folder_shared_rounded,
                  onTap: () => Get.to(() => const ResourceLanding()),
                ),
                _CategoryCard(
                  image: 'assets/events.jpeg',
                  title: 'Events & Networking',
                  icon: Icons.event_note_rounded,
                  onTap: () => Get.to(() => const MainEvents()),
                ),
                _CategoryCard(
                  image: 'assets/youth.jpeg',
                  title: 'Youth Empowerment',
                  icon: Icons.school_rounded,
                  onTap: () => Get.to(() => const YouthResourceLanding()),
                ),
                _CategoryCard(
                  image: 'assets/creator.jpg',
                  title: 'The Creator',
                  icon: Icons.person_pin_rounded,
                  onTap: () => Get.to(() => const TheCreatorScreen()),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.image, required this.title, this.subtitle, required this.icon, required this.onTap});
  final String image;
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image with Overlay
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: _borderColor)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _silver.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(icon, color: _silver, size: 24),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(color: _silverDark, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
