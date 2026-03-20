import 'package:b2bmobile/Screens/pages/youth_resource.dart';
import 'package:b2bmobile/youthresource/my_youth_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/admin_panel/youth_requests/all_youth_support.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class YouthResourceLanding extends StatefulWidget {
  const YouthResourceLanding({super.key});

  @override
  State<YouthResourceLanding> createState() => _YouthResourceLandingState();
}

class _YouthResourceLandingState extends State<YouthResourceLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Youth Empowerment',
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
                child: Center(
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(Icons.school_rounded, size: 100, color: _silver),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUTH HUB',
                    style: TextStyle(color: _silverDark, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 20),
                  
                  _YouthOptionCard(
                    title: 'Share a Resource',
                    subtitle: 'Add a resource to empower our youth.',
                    icon: Icons.add_moderator_rounded,
                    onTap: () => Get.to(() => const YouthResource()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _YouthOptionCard(
                    title: 'My Shared Resources',
                    subtitle: 'Manage youth resources you have posted.',
                    icon: Icons.folder_shared_rounded,
                    onTap: () => Get.to(() => const MyYouthResources()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _YouthOptionCard(
                    title: 'Browse All Resources',
                    subtitle: 'Discover opportunities specifically for youth.',
                    icon: Icons.search_rounded,
                    onTap: () => Get.to(() => const AllYouth()),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _borderColor),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.auto_awesome_outlined, color: _silver, size: 32),
                        SizedBox(height: 16),
                        Text(
                          'Empowering Future Leaders',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Empowering Black youth is crucial for achieving equality, breaking generational cycles, fostering diversity, and nurturing social cohesion for society's well-being.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YouthOptionCard extends StatelessWidget {
  const _YouthOptionCard({required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF3A3A3C), Color(0xFF1C1C1E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(icon, color: _silver, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.2),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}
