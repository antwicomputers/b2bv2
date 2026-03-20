import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Pending Registrations — Admin Review Screen
// Shows every unverified item across all collections in one place.
// Admin can toggle individual flags and approve/reject.
// ──────────────────────────────────────────────────────────────────────────────

class PendingRegistrationsScreen extends StatelessWidget {
  const PendingRegistrationsScreen({super.key});

  /// All collections that feed into the pending queue.
  static const List<_CollectionMeta> _collections = [
    _CollectionMeta(
      collection: 'businesses',
      label: 'Businesses',
      icon: Icons.store,
      color: Color(0xFFE0E0E0), // Silver
    ),
    _CollectionMeta(
      collection: 'events',
      label: 'Events',
      icon: Icons.event,
      color: Color(0xFF64B5F6),
    ),
    _CollectionMeta(
      collection: 'supportbusinesses',
      label: 'Support Resources',
      icon: Icons.health_and_safety,
      color: Color(0xFF81C784),
    ),
    _CollectionMeta(
      collection: 'userresourcesupport',
      label: 'User Resources',
      icon: Icons.people,
      color: Color(0xFFFF8A65),
    ),
    _CollectionMeta(
      collection: 'youthresource',
      label: 'Youth Resources',
      icon: Icons.school,
      color: Color(0xFFBA68C8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _collections.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Pending Registrations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: _collections.map((m) {
              return Tab(
                icon: Icon(m.icon, size: 18),
                text: m.label,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: _collections.map((meta) {
            return _PendingTab(meta: meta);
          }).toList(),
        ),
      ),
    );
  }
}

// ── Per-tab stream list ──────────────────────────────────────────────────────

class _PendingTab extends StatelessWidget {
  const _PendingTab({required this.meta});
  final _CollectionMeta meta;

  bool get _isEvent => meta.collection == 'events';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(meta.collection)
          .where('isVerified', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                const SizedBox(height: 16),
                Text(
                  'No pending ${meta.label.toLowerCase()}!',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final id = docs[i].id;
            return _PendingCard(
              docId: id,
              data: data,
              collection: meta.collection,
              accentColor: meta.color,
              isEvent: _isEvent,
            );
          },
        );
      },
    );
  }
}

// ── Individual pending card ──────────────────────────────────────────────────

class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.docId,
    required this.data,
    required this.collection,
    required this.accentColor,
    required this.isEvent,
  });

  final String docId;
  final Map<String, dynamic> data;
  final String collection;
  final Color accentColor;
  final bool isEvent;

  String get _name =>
      data['businessName'] ??
      data['SupportName'] ??
      data['eventName'] ??
      'Unnamed';

  String get _description =>
      data['businessDescription'] ??
      data['SupportDescription'] ??
      data['eventDescription'] ??
      '';

  String get _category =>
      data['businessCategory'] ??
      data['SupportCategory'] ??
      data['eventCategory'] ??
      '';

  String get _address =>
      data['businessAddress'] ??
      data['SupportAddress'] ??
      data['eventAddress'] ??
      '';

  String get _imageUrl =>
      data['businessUrl'] ??
      data['SupportUrl'] ??
      data['eventUrl'] ??
      '';

  String get _submittedBy => data['userId'] ?? '';

  void _toggle(String field, bool current) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .update({field: !current});
  }

  void _deleteItem(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Delete Entry',
            style: TextStyle(color: Colors.white)),
        content: Text('Permanently delete "$_name"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVerified = data['isVerified'] ?? false;
    final bool isBlackOwned = data['isBlackOwned'] ?? false;
    final bool womenOriented = data['womenOriented'] ?? false;
    final bool isEsential = data['isEsential'] ?? false;
    final bool isFeatured = data['isFeatured'] ?? false;
    final bool isSponsored = data['isSponsored'] ?? false;
    // Events specific
    final bool isSponsered = data['isSponsered'] ?? false;
    final bool isWomenOriented = data['isWomenOriented'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with image ──────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _imageUrl.isNotEmpty
                ? Image.network(
                    _imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),

          // ── Title row ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: accentColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Delete button
                IconButton(
                  onPressed: () => _deleteItem(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Reject & Delete',
                ),
              ],
            ),
          ),

          // ── Info chips ────────────────────────────────────────────────
          if (_category.isNotEmpty || _address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (_category.isNotEmpty)
                    _chip(Icons.category, _category, Colors.blueGrey),
                  if (_address.isNotEmpty)
                    _chip(Icons.location_on, _address, Colors.teal),
                ],
              ),
            ),

          // ── Description ───────────────────────────────────────────────
          if (_description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                _description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ),

          // ── Submitted by ──────────────────────────────────────────────
          if (_submittedBy.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                'User ID: $_submittedBy',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),

          const Divider(color: Colors.white12, height: 24),

          // ── Approval toggle (prominent) ─────────────────────────────
          _buildApproveRow(isVerified),

          const Divider(color: Colors.white12, height: 8),

          // ── Attribute toggles ─────────────────────────────────────────
          if (!isEvent) ...[
            _toggle2('isBlackOwned', 'Black Owned', isBlackOwned, Colors.white),
            _toggle2('womenOriented', 'Women Oriented', womenOriented, Colors.pinkAccent),
            _toggle2('isEsential', 'Essential Service', isEsential, Colors.orangeAccent),
            _toggle2('isFeatured', 'Featured', isFeatured, Colors.purpleAccent),
            _toggle2('isSponsored', 'Sponsored', isSponsored, Colors.greenAccent),
          ] else ...[
            _toggle2('isSponsered', 'Sponsored', isSponsered, Colors.greenAccent),
            _toggle2('isWomenOriented', 'Women Oriented', isWomenOriented, Colors.pinkAccent),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 160,
        color: const Color(0xFF2A2A2A),
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.white24, size: 48),
        ),
      );

  Widget _chip(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: color, fontSize: 11),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );

  Widget _buildApproveRow(bool isVerified) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: isVerified
              ? Colors.green.withValues(alpha: 0.15)
              : Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          child: SwitchListTile(
            dense: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            value: isVerified,
            onChanged: (_) => _toggle('isVerified', isVerified),
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
            title: Text(
              isVerified ? '✅  APPROVED — visible in app' : '⏳  Awaiting Approval',
              style: TextStyle(
                color: isVerified ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );

  Widget _toggle2(String field, String label, bool value, Color activeColor) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: SwitchListTile(
          dense: true,
          value: value,
          onChanged: (_) => _toggle(field, value),
          activeColor: activeColor,
          title: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      );
}

// ── Metadata helper ──────────────────────────────────────────────────────────

class _CollectionMeta {
  const _CollectionMeta({
    required this.collection,
    required this.label,
    required this.icon,
    required this.color,
  });
  final String collection;
  final String label;
  final IconData icon;
  final Color color;
}
