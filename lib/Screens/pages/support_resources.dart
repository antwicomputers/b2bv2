import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/support.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class SupportResources extends StatefulWidget {
  const SupportResources({super.key});

  @override
  State<SupportResources> createState() => _SupportResourcesState();
}

class _SupportResourcesState extends State<SupportResources> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
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
                  'Support Resources',
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
                      child: Icon(Icons.health_and_safety_rounded, size: 100, color: _silver),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: const Text(
                  'VERIFIED RESOURCES',
                  style: TextStyle(color: _silverDark, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('supportbusinesses')
                  .where('isBlackOwned', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: _silver))),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No resources available', style: TextStyle(color: Colors.white38)))),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final support = Support.fromMap(data);
                      if (!support.isVerified) return const SizedBox.shrink();
                      return SupportCardWidget(support: support);
                    },
                    childCount: docs.length,
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class SupportCardWidget extends StatelessWidget {
  const SupportCardWidget({super.key, required this.support});
  final Support support;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => UniversalDetailScreen(item: support.toDetailItem())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                support.supportUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _borderColor, width: 100, height: 100, child: const Icon(Icons.image_not_supported, color: Colors.white24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    support.supportName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    support.supportDescription,
                    style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: _silver.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Resource', style: TextStyle(color: _silver, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
