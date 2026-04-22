import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal & Compliance'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildLegalSection(
            context,
            title: 'Privacy Policy',
            content: "Last Updated: March 2026\n\nYour privacy is paramount. Back2Black collects and uses certain information to provide and improve our platform's services. We do not sell your personal data to third parties. We use encryption to protect your data while in transit and at rest.",
          ),
          const SizedBox(height: 32),
          _buildLegalSection(
            context,
            title: 'Terms of Service',
            content: "By accessing or using the Back2Black platform, you agree to comply with our community standards. We maintain a zero-tolerance policy towards harassment, illegal trade, and discriminatory behavior. Accounts found in violation will be permanently suspended.",
          ),
          const SizedBox(height: 32),
          _buildLegalSection(
            context,
            title: 'Community Guidelines',
            content: "Back2Black is a platform built for empowerment. We encourage mutual support, respect, and economic collaboration within the community.",
          ),
          const SizedBox(height: 60),
          Center(
            child: Text(
              "Version 1.0.0 (Building for the Future)",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context, {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          )
        ),
        const SizedBox(height: 12),
        Text(
          content, 
          style: const TextStyle(
            height: 1.6, 
            color: Colors.white70,
            fontSize: 15,
          )
        ),
      ],
    );
  }
}
