import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class TheCreatorScreen extends StatelessWidget {
  const TheCreatorScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@antwicomputers.com',
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
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
                  Image.asset(
                    "assets/creator.jpg",
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "The Creator",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "AI Architect & Founder",
                    style: TextStyle(
                      color: _silverDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _SectionHeader(title: "THE VISION"),
                  const SizedBox(height: 16),
                  const Text(
                    "Hi, I'm Charles Antwi — creator and founder of Antwi Computers.",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome to Back2Black Mobile, an AI-powered B2B ecosystem designed to engineer the ultimate networking experience for Black excellence. My mission is to build a modern-day Digital Black Wall Street where intelligent matchmaking and personalized discovery circulate capital and professional resources back into our community.",
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Whether you're looking for verified professional services, growth capital, or a personalized 'handpicked' journey, this ecosystem is designed to be your primary hub for exponential growth.",
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  _SectionHeader(title: "ECOSYSTEM FEATURES"),
                  const SizedBox(height: 16),
                  
                  const _FeatureItem(
                    icon: Icons.auto_awesome,
                    title: "Intelligent AI Matchmaking",
                    description: "Our 'Handpicked for You' engine leverages behavioral AI and user interests to dynamically match you with the most relevant businesses and resources in real-time.",
                  ),
                  const _FeatureItem(
                    icon: Icons.security_rounded,
                    title: "AI Review Integrity System",
                    description: "An automated trust layer for the marketplace. Every review is AI-analyzed for authenticity and cross-verified against your behavioral history to eliminate fraud and spam.",
                  ),
                  const _FeatureItem(
                    icon: Icons.map_rounded,
                    title: "The Interactive Map",
                    description: "Discover Black-owned businesses securely mapped around you. The map is dynamically filtered, pulling verified venues directly to your fingertips.",
                  ),
                  const _FeatureItem(
                    icon: Icons.verified_rounded,
                    title: "Verified Community Reviews",
                    description: "A centralized trust hub. Share your experiences and see verified reviews from real community members. Quality and trust are the foundation of our network.",
                  ),
                  const _FeatureItem(
                    icon: Icons.swap_horiz_rounded,
                    title: "B2B RFP Service Board",
                    description: "Forcing the dollar to circulate. If you need a lawyer, accountant, or designer for your startup, post an RFP and let verified services pitch to you.",
                  ),
                  const _FeatureItem(
                    icon: Icons.rocket_launch_rounded,
                    title: "The Black KickStart (BKS)",
                    description: "More than a directory, this is an actionable incubator. We've introduced Mentorship Pledges where seasoned business owners pledge tangible mentor hours.",
                  ),
                  const _FeatureItem(
                    icon: Icons.play_circle_filled_rounded,
                    title: "The Pulse Discovery Feed",
                    description: "A dynamic, full-screen scrolling experience designed to visually highlight and discover premium verified Black businesses locally and globally.",
                  ),
                  
                  const SizedBox(height: 40),
                  
                  _SectionHeader(title: "BRING YOUR IDEAS TO LIFE"),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _borderColor),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.bolt_rounded, color: _silver, size: 32),
                        SizedBox(height: 16),
                        Text(
                          "From Vision to Reality in 14 Days",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "I am a specialized app developer dedicated to speed and quality. I can bring your digital ideas to life in just 14 days. Let's build the future together.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  _SectionHeader(title: "CONTACT & CONNECT"),
                  const SizedBox(height: 20),
                  
                  _ContactTile(
                    icon: Icons.language_rounded,
                    title: "Website",
                    value: "antwicomputers.com",
                    onTap: () => _launchURL("https://www.antwicomputers.com"),
                  ),
                  const SizedBox(height: 16),
                  _ContactTile(
                    icon: Icons.email_outlined,
                    title: "Email",
                    value: "info@antwicomputers.com",
                    onTap: _sendEmail,
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _silverDark,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
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
                    style: const TextStyle(color: _silverDark, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded, color: Colors.white24, size: 18),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
