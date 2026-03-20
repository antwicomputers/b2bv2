import 'package:b2bmobile/Screens/black_kick_start/support_business.dart';
import 'package:b2bmobile/Screens/pages/support_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class KickStartLanding extends StatefulWidget {
  const KickStartLanding({super.key});

  @override
  State<KickStartLanding> createState() => _KickStartLandingState();
}

class _KickStartLandingState extends State<KickStartLanding> {
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
                'Black KickStart',
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
                    child: Icon(Icons.rocket_launch, size: 100, color: _silver),
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
                    'CHOOSE AN OPTION',
                    style: TextStyle(color: _silverDark, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 20),
                  
                  _OptionCard(
                    title: 'Support Black Owned Businesses',
                    subtitle: 'Offer mentorship, donations, or services to help others grow.',
                    icon: Icons.add_moderator_rounded,
                    onTap: () => Get.to(() => const SupportBusiness()),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _OptionCard(
                    title: 'Browse Support Resources',
                    subtitle: 'Find mentorship opportunities and resources to jumpstart your business.',
                    icon: Icons.search_rounded,
                    onTap: () => Get.to(() => const SupportResources()),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _borderColor),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.hub_outlined, color: _silver, size: 32),
                        SizedBox(height: 16),
                        Text(
                          'Why Networking Matters',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Networking helps Black businesses and individuals access career opportunities, funding, and critical resources to achieve their goals. It also works to break down isolation, providing a vital sense of belonging and community connection.',
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

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6)),
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
              child: Icon(icon, color: _silver, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}
