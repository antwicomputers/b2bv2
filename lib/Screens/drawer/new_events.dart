import 'package:b2bmobile/Screens/drawer/register_event.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/all_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/my_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/past_events.dart';
import 'package:b2bmobile/Screens/vew%20all%20events/sponsored_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class MainEvents extends StatefulWidget {
  const MainEvents({super.key});

  @override
  State<MainEvents> createState() => _MainEventsState();
}

class _MainEventsState extends State<MainEvents> {
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
                'Event Management',
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
                    child: Icon(Icons.event_note_rounded, size: 100, color: _silver),
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
                    'EVENT OPTIONS',
                    style: TextStyle(color: _silverDark, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 20),
                  
                  _EventOptionCard(
                    title: 'Register Event',
                    subtitle: 'Create a new networking opportunity.',
                    icon: Icons.event_available_rounded,
                    onTap: () => Get.to(() => const RegisterEvent()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _EventOptionCard(
                    title: 'My Events',
                    subtitle: 'Manage and update your registrations.',
                    icon: Icons.history_edu_rounded,
                    onTap: () => Get.to(() => const MyEvents()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _EventOptionCard(
                    title: 'All Upcoming Events',
                    subtitle: 'Browse all upcoming networking sessions.',
                    icon: Icons.calendar_month_rounded,
                    onTap: () => Get.to(() => const AllEvents()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _EventOptionCard(
                    title: 'Sponsored Events',
                    subtitle: 'Premium events from our top partners.',
                    icon: Icons.emoji_events_rounded,
                    onTap: () => Get.to(() => const SponsoredEvents()),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _EventOptionCard(
                    title: 'Past Events',
                    subtitle: 'View archive of completed gatherings.',
                    icon: Icons.event_repeat_rounded,
                    onTap: () => Get.to(() => const PastEvents()),
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
                        Icon(Icons.diversity_3_outlined, color: _silver, size: 32),
                        SizedBox(height: 16),
                        Text(
                          'The Power of Networking',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Networking is vital in the black community for sharing resources, building relationships, and overcoming systemic barriers to success.',
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

class _EventOptionCard extends StatelessWidget {
  const _EventOptionCard({required this.title, required this.subtitle, required this.icon, required this.onTap});
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
