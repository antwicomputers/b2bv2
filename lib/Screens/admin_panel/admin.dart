import 'dart:async';
import 'package:b2bmobile/Screens/admin_panel/all_feedback.dart';
import 'package:b2bmobile/Screens/admin_panel/event%20request%20/event_request_screen.dart';
import 'package:b2bmobile/Screens/admin_panel/pending_registrations.dart';
import 'package:b2bmobile/Screens/admin_panel/report_business.dart';
import 'package:b2bmobile/Screens/admin_panel/support_request/support_request_screen.dart';
import 'package:b2bmobile/Screens/admin_panel/youth_requests/youth_request_screen.dart';
import 'package:b2bmobile/Screens/verification%20request/verification_request_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:b2bmobile/Screens/admin_panel/all_businesses.dart';
import 'package:get/get.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Pending banner with live badge ─────────────────────────
            _PendingBanner(),
            const SizedBox(height: 24),

            // ── Section heading ────────────────────────────────────────
            const Text(
              'Management',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // ── Grid of admin tools ────────────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _AdminCard(
                  icon: Icons.verified,
                  label: 'Verification\nRequests',
                  color: const Color(0xFFFFD700),
                  onTap: () => Get.to(() => const VerificationScreen()),
                ),
                _AdminCard(
                  icon: Icons.store,
                  label: 'All\nBusinesses',
                  color: const Color(0xFF64B5F6),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const BusinessAll(),
                  )),
                ),
                _AdminCard(
                  icon: Icons.health_and_safety,
                  label: 'Support\nVerification',
                  color: const Color(0xFF81C784),
                  onTap: () => Get.to(() => const SupportRequest()),
                ),
                _AdminCard(
                  icon: Icons.event,
                  label: 'Event\nRequests',
                  color: const Color(0xFFFF8A65),
                  onTap: () => Get.to(() => const EventRequestScreen()),
                ),
                _AdminCard(
                  icon: Icons.thumb_down_alt_outlined,
                  label: 'Business\nFeedback',
                  color: const Color(0xFFBA68C8),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const BusinessReport(),
                  )),
                ),
                _AdminCard(
                  icon: Icons.forum,
                  label: 'All\nFeedback',
                  color: const Color(0xFF4DB6AC),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AllFeedback(),
                  )),
                ),
                _AdminCard(
                  icon: Icons.school,
                  label: 'Youth\nRequests',
                  color: const Color(0xFFF06292),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const YouthRequestScreen(),
                  )),
                ),
                _AdminCard(
                  icon: Icons.send,
                  label: 'Send\nAlert',
                  color: const Color(0xFF90A4AE),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AllBusinesses(),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pending banner with live Firestore count badge ────────────────────────────

class _PendingBanner extends StatefulWidget {
  const _PendingBanner();

  @override
  State<_PendingBanner> createState() => _PendingBannerState();
}

class _PendingBannerState extends State<_PendingBanner> {
  /// Collections to count unverified items from.
  static const _pendingCollections = [
    'businesses',
    'events',
    'supportbusinesses',
    'userresourcesupport',
    'youthresource',
  ];

  final Map<String, int> _counts = {};
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _initStreams();
  }

  void _initStreams() {
    for (var collection in _pendingCollections) {
      final sub = FirebaseFirestore.instance
          .collection(collection)
          .where('isVerified', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        if (!mounted) return;
        setState(() {
          _counts[collection] = snapshot.docs.length;
        });
      });
      _subscriptions.add(sub);
    }
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  int get _total => _counts.values.fold(0, (sum, count) => sum + count);

  @override
  Widget build(BuildContext context) {
    final total = _total;

    return GestureDetector(
      onTap: () => Get.to(() => const PendingRegistrationsScreen()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: total > 0
                ? [
                    const Color(0xFFFF6B35),
                    const Color(0xFFCC3300),
                  ]
                : [
                    const Color(0xFF2E7D32),
                    const Color(0xFF1B5E20),
                  ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: (total > 0 ? Colors.redAccent : Colors.green)
                  .withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  total > 0 ? Icons.pending_actions : Icons.check_circle,
                  key: ValueKey(total > 0),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    total > 0
                        ? '$total Pending Registration${total == 1 ? '' : 's'}'
                        : 'All Clear!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total > 0
                        ? 'Tap to review and approve submissions'
                        : 'No pending submissions right now',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

// ── Admin grid card ───────────────────────────────────────────────────────────

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Legacy stub kept for import compatibility ─────────────────────────────────
class AllBusinesses extends StatelessWidget {
  const AllBusinesses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Alert'),
        backgroundColor: Colors.black,
      ),
      body: const Center(child: Text('Alert functionality coming soon')),
    );
  }
}
