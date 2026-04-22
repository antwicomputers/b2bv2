import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/utils/utils.dart';
import 'package:b2bmobile/services/ai_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

class VerificationScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<Uint8List> images;
  final String type; // 'business', 'event', 'support'

  const VerificationScreen({
    super.key,
    required this.data,
    required this.images,
    required this.type,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoading = false;
  String? _aiReview;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _runAIReview();
  }

  Future<void> _runAIReview() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userModel == null || !userProvider.userModel!.isBlack) {
      return;
    }

    setState(() => _isAnalyzing = true);
    final review = await AIService().reviewBusinessSubmission(widget.data);
    if (mounted) {
      setState(() {
        _aiReview = review;
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    String message = 'error';
    
    if (widget.type == 'business') {
      message = await userProvider.registerBusiness(
        businessName: widget.data['businessName'],
        businessDescription: widget.data['businessDescription'],
        businessAddress: widget.data['businessAddress'],
        businessCategory: widget.data['businessCategory'],
        phone: widget.data['phone'],
        email: widget.data['email'],
        website: widget.data['website'],
        twitter: widget.data['twitter'],
        facebook: widget.data['facebook'],
        instagram: widget.data['instagram'],
        tiktok: widget.data['tiktok'],
        linkedIn: widget.data['linkedIn'],
        youtube: widget.data['youtube'],
        twitch: widget.data['twitch'],
        podcast: widget.data['podcast'],
        images: widget.images,
        isBlackOwned: false, // Will be set by Admin
        isEsential: false,
        womenOriented: false,
        operatingModel: widget.data['operatingModel'] ?? 'physical',
        isGlobal: widget.data['isGlobal'] ?? false,
        offersRewards: widget.data['offersRewards'] ?? false,
        silverReward: widget.data['silverReward'] ?? '',
        goldReward: widget.data['goldReward'] ?? '',
        eliteReward: widget.data['eliteReward'] ?? '',
      );
    }
    // Handle other types later if needed
    
    setState(() => _isLoading = false);
    
    if (message == 'success') {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userProvider.userModel?.uid).set({
          'points': FieldValue.increment(50),
        }, SetOptions(merge: true));
      } catch (_) {}

      Get.offAll(() => const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ));
      if (mounted) showSnackBar('Listing submitted for review!', context);
    } else {
      if (mounted) showSnackBar(message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Review Listing', style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify your information before submitting. This helps us minimize processing costs and ensures data accuracy.',
              style: GoogleFonts.outfit(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 32),
            if (_isAnalyzing || _aiReview != null) ...[
              Text('AI REVIEWER ANALYSIS', style: GoogleFonts.bebasNeue(color: Colors.white, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: _isAnalyzing 
                  ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white60)))
                  : Text(_aiReview ?? "No review available.", style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, height: 1.5)),
              ),
              const SizedBox(height: 32),
            ],
            
            // Image Preview
            Text('GALLERY', style: GoogleFonts.bebasNeue(color: Colors.white38, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) => Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: MemoryImage(widget.images[index]), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            _buildReviewItem('NAME', widget.data['businessName']),
            _buildReviewItem('CATEGORY', widget.data['businessCategory']),
            _buildReviewItem('ADDRESS', widget.data['businessAddress']),
            _buildReviewItem('DESCRIPTION', widget.data['businessDescription']),
            
            const Divider(color: Colors.white12, height: 40),
            
            _buildReviewItem('CONTACT', '${widget.data['phone']} \n${widget.data['email']}'),
            _buildReviewItem('WEBSITE', widget.data['website']),

            const SizedBox(height: 48),
            
            GestureDetector(
              onTap: _isLoading ? null : _submit,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.white, Color(0xFFC0C0C0)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text('CONFIRM & SUBMIT', style: GoogleFonts.bebasNeue(color: Colors.black, fontSize: 18, letterSpacing: 1.5)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text('GO BACK & EDIT', style: GoogleFonts.outfit(color: Colors.white38)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.bebasNeue(color: Colors.white38, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
