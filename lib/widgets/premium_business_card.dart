import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:b2bmobile/models/detail_item.dart';
import 'package:b2bmobile/Screens/pages/universal_detail_screen.dart';

class PremiumBusinessCard extends StatelessWidget {
  const PremiumBusinessCard({
    super.key,
    required this.item,
    required this.size,
    this.isGrid = false,
  });

  final DetailItem item;
  final Size size;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isGrid ? 0 : 18.0, top: 4, bottom: 12),
      child: GestureDetector(
        onTap: () => Get.to(() => UniversalDetailScreen(item: item)),
        child: Container(
          width: isGrid ? double.infinity : (size.width < 400 ? 140 : 160),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Color Layer (Providing context for contained logos)
              Container(color: Colors.white10),
              
              // Main Image Layer (High-End Float)
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Image.network(
                      item.imageUrl.isNotEmpty ? item.imageUrl : 'https://images.unsplash.com/photo-1542204165-65bf26472b9b',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.business, color: Colors.black26, size: 28)),
                    ),
                  ),
                ),
              ),
              // Premium Dark Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Text Content at Bottom
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (item.isBlackOwned)
                          _cardBadge('BLACK-OWNED', const Color(0xFFFFD700)),
                        if (item.isSponsored)
                          _cardBadge('SPONSOR', Colors.amber),
                        if (item.isVerified && !item.isBlackOwned && !item.isSponsored)
                          _cardBadge('VERIFIED', Colors.white),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.name,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category.toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: Colors.white54,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
