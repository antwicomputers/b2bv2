import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class PledgeTrackerWidget extends StatefulWidget {
  final String targetId;
  const PledgeTrackerWidget({super.key, required this.targetId});

  @override
  State<PledgeTrackerWidget> createState() => _PledgeTrackerWidgetState();
}

class _PledgeTrackerWidgetState extends State<PledgeTrackerWidget> {
  bool _isPledging = false;

  void _pledgeHours() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.userModel;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to pledge.');
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Pledge Mentorship', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to pledge 1 hour of your time to mentor this Black Kickstart founder? You will be contacted via email to coordinate.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Pledge 1 Hour', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    setState(() => _isPledging = true);

    try {
      await FirebaseFirestore.instance.collection('pledges').add({
        'targetId': widget.targetId,
        'userId': user.uid,
        'userName': user.fullname.isEmpty ? user.username : user.fullname,
        'hours': 1,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'points': FieldValue.increment(200),
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Thank you for pledging to guide the next generation!', backgroundColor: Colors.green.withValues(alpha: 0.2), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Could not pledge: $e');
    } finally {
      setState(() => _isPledging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pledges')
          .where('targetId', isEqualTo: widget.targetId)
          .snapshots(),
      builder: (context, snapshot) {
        int totalHours = 0;
        int goalHours = 20; // Default goal
        
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            totalHours += (data['hours'] as num?)?.toInt() ?? 0;
          }
        }

        double progress = (totalHours / goalHours).clamp(0.0, 1.0);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("BKS MENTORSHIP GOAL", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const Icon(Icons.rocket_launch, color: Colors.white54, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(totalHours.toString(), style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1)),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text("/ $goalHours hours raised", style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _isPledging ? null : _pledgeHours,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.white, Color(0xFFC0C0C0)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _isPledging 
                       ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 2))
                       : const Text('Pledge 1 Mentorship Hour', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
