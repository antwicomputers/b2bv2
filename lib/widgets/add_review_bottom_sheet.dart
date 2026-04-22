import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/models/review.dart';
import 'package:b2bmobile/services/review_integrity_service.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String targetId;
  const AddReviewBottomSheet({super.key, required this.targetId});

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  void _submitReview() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.userModel;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to leave a review.');
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Please provide a comment.');
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Confirm Review', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to post this review? To maintain community trust, please ensure your review is honest and respectful.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Post Review', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = FirebaseFirestore.instance.collection('reviews').doc();
      final draftReview = Review(
        id: docRef.id,
        targetId: widget.targetId,
        userId: user.uid,
        userName: user.fullname,
        userPhoto: user.photoUrl,
        rating: _rating,
        comment: _commentController.text.trim(),
        imageUrl: '', // Optional: Add image upload later if needed
        timestamp: DateTime.now(),
      );

      // AI Integrity Layer: Analyze the review before posting
      final analyzedReview = await ReviewIntegrityService().analyzeReview(draftReview, user);

      await docRef.set(analyzedReview.toMap());
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'points': FieldValue.increment(25),
      }, SetOptions(merge: true));
      
      setState(() {
        _isLoading = false;
      });
      
      Get.back(); // Close bottom sheet
      Get.snackbar('Success', 'Your review has been verified and posted!', backgroundColor: Colors.green.withValues(alpha: 0.2), colorText: Colors.white);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4, width: 40,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Leave a Review', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share your experience with the community...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _isLoading ? null : _submitReview,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.white, Color(0xFFC0C0C0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('Post Verified Review', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
