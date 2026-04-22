import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:b2bmobile/models/rfp.dart';
import 'package:b2bmobile/providers/user_provider.dart';
import 'package:b2bmobile/Screens/pages/rfp_pitches_screen.dart';
import 'package:b2bmobile/utils/categories.dart';

class B2BServiceBoard extends StatefulWidget {
  const B2BServiceBoard({super.key});

  @override
  State<B2BServiceBoard> createState() => _B2BServiceBoardState();
}

class _B2BServiceBoardState extends State<B2BServiceBoard> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', ...appCategories.where((c) => c != 'Other')];

  void _showPostNeedSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PostRfpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text('B2B Service Board', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          TextButton.icon(
             icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
             label: const Text("Post Need", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
             onPressed: _showPostNeedSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "Circulate the dollar. Post a Request for Proposal (RFP) to hire Black-owned essential services for your startup.",
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
          // Categories
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? Colors.white : Colors.white12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: GoogleFonts.outfit(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rfps')
                  .where('isActive', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white24));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No open proposals currently.", style: TextStyle(color: Colors.white54)),
                  );
                }

                var docs = snapshot.data!.docs.map((doc) => RFP.fromMap(doc.data() as Map<String, dynamic>)).toList();
                
                if (_selectedCategory != 'All') {
                  docs = docs.where((doc) => doc.category == _selectedCategory).toList();
                }

                docs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final rfp = docs[index];
                    return _RfpCard(rfp: rfp);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RfpCard extends StatelessWidget {
  const _RfpCard({required this.rfp});
  final RFP rfp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      rfp.category.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                  if (DateTime.now().difference(rfp.timestamp).inHours < 48)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber.withValues(alpha: 0.4))),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_open, color: Colors.amber, size: 10),
                          SizedBox(width: 4),
                          Text("FIRST LOOK", style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ]
                      ),
                    ),
                ],
              ),
              Text(
                DateFormat('MMM d').format(rfp.timestamp),
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(rfp.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            rfp.description,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.monetization_on_outlined, color: Colors.green, size: 16),
              const SizedBox(width: 6),
              Text("Budget: ${rfp.budget}", style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF1E1E1E),
                backgroundImage: rfp.authorPhoto.isNotEmpty ? NetworkImage(rfp.authorPhoto) : null,
                child: rfp.authorPhoto.isEmpty ? const Icon(Icons.person, color: Colors.white30, size: 14) : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text("Posted by ${rfp.authorName}", style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Consumer<UserProvider>(
                builder: (context, userProv, _) {
                  final user = userProv.userModel;
                  if (user == null) return const SizedBox.shrink();

                  final bool isAuthor = user.uid == rfp.authorId;

                  if (isAuthor) {
                    return GestureDetector(
                      onTap: () {
                         Get.to(() => RFPPitchesScreen(rfpId: rfp.id, rfpTitle: rfp.title));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                        child: const Text("View Pitches", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                         .collection('businesses')
                         .where('userId', isEqualTo: user.uid)
                         .where('isVerified', isEqualTo: true)
                         .limit(1)
                         .get(),
                    builder: (context, snapshot) {
                      bool hasVerifiedBusiness = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                      bool isPremium = false;
                      Map<String, dynamic>? businessData;
                      
                      if (hasVerifiedBusiness) {
                         businessData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                         isPremium = businessData['isBlackOwned'] == true;
                      }

                      bool isFirstLook = DateTime.now().difference(rfp.timestamp).inHours < 48;

                      return GestureDetector(
                        onTap: () async {
                           if (!hasVerifiedBusiness) {
                              Get.showSnackbar(const GetSnackBar(
                                 title: "Verification Required",
                                 message: "You must have a Verified business registered on the app to pitch.",
                                 backgroundColor: Colors.redAccent,
                                 duration: Duration(seconds: 4),
                              ));
                              return;
                           }

                           if (isFirstLook && !isPremium) {
                              Get.showSnackbar(GetSnackBar(
                                 title: "First Look Locked 🔒",
                                 message: "This RFP is in First Look mode. Only Verified Premium businesses can pitch for the first 48 hours.",
                                 backgroundColor: Colors.amber.shade900,
                                 duration: const Duration(seconds: 4),
                              ));
                              return;
                           }

                           bool confirm = await showDialog(
                             context: context,
                             builder: (ctx) => AlertDialog(
                               backgroundColor: const Color(0xFF1E1E1E),
                               title: const Text('Pitch Service?', style: TextStyle(color: Colors.white)),
                               content: Text('Are you sure you want to pitch your service to ${rfp.authorName}? This will notify them to review your profile.', style: const TextStyle(color: Colors.white70)),
                               actions: [
                                 TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
                                 ElevatedButton(
                                   style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                   onPressed: () => Navigator.of(ctx).pop(true),
                                   child: const Text('Pitch Now', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                                 ),
                               ],
                             ),
                           ) ?? false;
                           
                           if (!confirm) return;

                           if (businessData == null) return;
                           
                           final String businessId = businessData['businessId'] ?? '';
                           final String businessName = businessData['businessName'] ?? '';
                           final String businessEmail = businessData['email'] ?? '';

                           // Record the pitch
                           await FirebaseFirestore.instance.collection('rfps').doc(rfp.id).collection('pitches').doc(user.uid).set({
                              'pitcherId': user.uid,
                              'pitcherName': user.fullname.isNotEmpty ? user.fullname : user.username,
                              'pitcherPhoto': user.photoUrl,
                              'businessId': businessId,
                              'businessName': businessName,
                              'businessEmail': businessEmail,
                              'timestamp': FieldValue.serverTimestamp(),
                           });

                           // Add Gamification Points
                           await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                             'points': FieldValue.increment(25),
                           }, SetOptions(merge: true));

                           Get.showSnackbar(GetSnackBar(
                              title: "Pitch Initiated (+25 Points)",
                              message: "Notification sent to ${rfp.authorName} that you are interested in pitching.",
                              backgroundColor: Colors.grey.shade900,
                              duration: const Duration(seconds: 3),
                           ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: const Text("Pitch Service", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostRfpSheet extends StatefulWidget {
  const _PostRfpSheet();

  @override
  State<_PostRfpSheet> createState() => _PostRfpSheetState();
}

class _PostRfpSheetState extends State<_PostRfpSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController(text: 'Negotiable');
  final _catController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty || _catController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all the details including the service category.');
      return;
    }

    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = provider.userModel;
    if (user == null) return;

    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Post RFP?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to post this Request for Proposal to the community?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Post Now', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ) ?? false;
    
    if (!confirm) return;

    setState(() => _isLoading = true);
    
    final docRef = FirebaseFirestore.instance.collection('rfps').doc();
    final rfp = RFP(
      id: docRef.id,
      authorId: user.uid,
      authorName: user.fullname.isEmpty ? user.username : user.fullname,
      authorPhoto: user.photoUrl,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _catController.text.trim(),
      budget: _budgetController.text.trim(),
      timestamp: DateTime.now(),
      isActive: true,
    );

    await docRef.set(rfp.toMap());
    
    // Add Points
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'points': FieldValue.increment(50),
    }, SetOptions(merge: true));

    setState(() => _isLoading = false);
    Get.back();
    Get.snackbar('Success', 'Your RFP is live! You earned 50 Points.', backgroundColor: Colors.green.withValues(alpha: 0.2), colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Post an RFP (Need)', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('What Essential Service does your business need?', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 20),
          
          LayoutBuilder(
            builder: (context, constraints) {
              return Autocomplete<String>(
                 optionsBuilder: (TextEditingValue textEditingValue) {
                   if (textEditingValue.text.isEmpty) {
                     return appCategories.where((c) => c != 'Other');
                   }
                   return appCategories.where((String option) {
                     return option.toLowerCase().contains(textEditingValue.text.toLowerCase()) && option != 'Other';
                   });
                 },
                 onSelected: (String selection) {
                   _catController.text = selection;
                 },
                 fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                   return TextField(
                     controller: controller,
                     focusNode: focusNode,
                     style: const TextStyle(color: Colors.white),
                     onChanged: (v) {
                       _catController.text = v;
                     },
                     onSubmitted: (v) {
                       _catController.text = v;
                     },
                     decoration: InputDecoration(
                       hintText: 'Search or Type Service (e.g. Tutor)',
                       hintStyle: const TextStyle(color: Colors.white38),
                       filled: true,
                       fillColor: const Color(0xFF1E1E1E),
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                       contentPadding: const EdgeInsets.all(16),
                       suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white30),
                     ),
                   );
                 },
                 optionsViewBuilder: (context, onSelected, options) {
                   return Align(
                     alignment: Alignment.topLeft,
                     child: Material(
                       color: const Color(0xFF1E1E1E),
                       elevation: 4.0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white12)),
                       child: ConstrainedBox(
                         constraints: BoxConstraints(maxHeight: 200, maxWidth: constraints.maxWidth),
                         child: ListView.builder(
                           padding: EdgeInsets.zero,
                           shrinkWrap: true,
                           itemCount: options.length,
                           itemBuilder: (BuildContext context, int index) {
                             final option = options.elementAt(index);
                             return InkWell(
                               onTap: () {
                                 onSelected(option);
                               },
                               child: Container(
                                 padding: const EdgeInsets.all(16.0),
                                 decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.white12, width: 0.5)),
                                 ),
                                 child: Text(option, style: const TextStyle(color: Colors.white)),
                               ),
                             );
                           },
                         ),
                       ),
                     ),
                   );
                 },
              );
            }
          ),
          const SizedBox(height: 12),
          
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Title (e.g. Need a CPA for LLC Setup)',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _descController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
               hintText: 'Describe exactly what you are looking for...',
               hintStyle: const TextStyle(color: Colors.white38),
               filled: true,
               fillColor: const Color(0xFF1E1E1E),
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _budgetController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Budget (e.g. \$500 or Negotiable)',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          
          GestureDetector(
            onTap: _isLoading ? null : _submit,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFC0C0C0)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isLoading 
                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 2))
                   : const Text('Post RFP to Network', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
