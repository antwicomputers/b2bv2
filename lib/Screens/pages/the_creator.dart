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
                    "Innovator & Developer",
                    style: TextStyle(
                      color: _silverDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _SectionHeader(title: "ABOUT ME"),
                  const SizedBox(height: 16),
                  const Text(
                    "I created Back2Black Mobile with a clear purpose: to bridge the gap between shoppers and Black-owned businesses. My mission is to empower our community by making it effortless to locate, support, and generate revenue for Black entrepreneurs.",
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Whether you're looking for a service, an event, or professional support, this app is designed to be your primary hub for growth and connection within the community.",
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
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
