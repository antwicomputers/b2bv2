import 'package:b2bmobile/Screens/pages/kick_start_landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
// const _cardBg = Color(0xFF141414); // removed unused element
// const _borderColor = Color(0xFF2A2A2A); // removed unused element

class BlackKickStart extends StatefulWidget {
  const BlackKickStart({super.key});

  @override
  State<BlackKickStart> createState() => _BlackKickStartState();
}

class _BlackKickStartState extends State<BlackKickStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset("assets/bks.jpeg", fit: BoxFit.cover),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: _silver.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('INITIATIVE', style: TextStyle(color: _silver, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "The Black KickStart",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Support Growth and Success",
                        style: TextStyle(color: _silverDark, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Introducing our latest initiative, The Black Kickstart program - an exclusive program designed to provide black-owned businesses with the boost they need to succeed.",
                        style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      _FeatureRow(icon: Icons.check_circle_outline, text: "Accelerate growth and streamline operations."),
                      _FeatureRow(icon: Icons.check_circle_outline, text: "Access mentorship and community services."),
                      _FeatureRow(icon: Icons.check_circle_outline, text: "Global database of resources and support."),
                      const SizedBox(height: 32),
                      const Text(
                        "Are you a resource willing to support the growth of black-owned businesses by providing mentorship, donations, or any other service? Join the movement today!",
                        style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.6, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Button Styled "Start Here"
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.to(() => const KickStartLanding()),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFC0C0C0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "START HERE",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: _silver, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14))),
        ],
      ),
    );
  }
}
