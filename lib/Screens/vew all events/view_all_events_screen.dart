import 'package:b2bmobile/models/detail_item_extensions.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';
import 'package:b2bmobile/models/events.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const _silver = Color(0xFFF5F5F7);
const _silverDark = Color(0xFF8E8E93);
const _cardBg = Color(0xFF141414);
const _borderColor = Color(0xFF2A2A2A);

class ViewAllEventsScreen extends StatefulWidget {
  const ViewAllEventsScreen({super.key});

  @override
  State<ViewAllEventsScreen> createState() => _ViewAllEventsScreenState();
}

class _ViewAllEventsScreenState extends State<ViewAllEventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                  'Explore Events',
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
                      child: Icon(Icons.event_seat_rounded, size: 100, color: _silver),
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.black,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: _silver,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'My'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                      Tab(text: 'Sponsored'),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildEventList(FirebaseFirestore.instance
                  .collection('events')
                  .where('userId', isEqualTo: value.getUser?.uid ?? '')),
              _buildEventList(FirebaseFirestore.instance
                  .collection('events')
                  .where('asTimeStamp', isGreaterThan: DateTime.now())
                  .where('isVerified', isEqualTo: true)),
              _buildEventList(FirebaseFirestore.instance
                  .collection('events')
                  .where('asTimeStamp', isLessThan: DateTime.now())
                  .where('isVerified', isEqualTo: true)
                  .limit(20)),
              _buildEventList(FirebaseFirestore.instance
                  .collection('events')
                  .where('isSponsered', isEqualTo: true)
                  .where('isVerified', isEqualTo: true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(Query query) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _silver));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('No events available', style: TextStyle(color: Colors.white38)));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final event = Events.fromMap(data);
            return EventCardWidget(event: event);
          },
        );
      },
    );
  }
}

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({super.key, required this.event});
  final Events event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => UniversalDetailScreen(item: event.toDetailItem())),
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
                event.eventUrl,
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
                    event.eventName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.eventDescription,
                    style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.event_outlined, color: _silverDark, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(event.eventDate),
                        style: const TextStyle(color: _silverDark, fontSize: 11),
                      ),
                      const Spacer(),
                      const Icon(Icons.people_outline, color: _silver, size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        '12 att.',
                        style: TextStyle(color: _silver, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
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
